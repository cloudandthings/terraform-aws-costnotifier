from collections import defaultdict
import boto3
import datetime
import os
import requests
import logging
import json

logger = logging.getLogger("cost notifier")
logger.setLevel(logging.INFO)

n_days = 7

AMBER_THRESHOLD = float(os.environ.get("AMBER_THRESHOLD", 20))
RED_THRESHOLD = float(os.environ.get("RED_THRESHOLD", 50))

WEBHOOK_URLS = json.loads(os.environ.get("WEBHOOK_URLS", []))
WEBHOOK_TYPE = os.environ.get("WEBHOOK_TYPE", "slack")

TOPIC_ARN = os.environ.get("SNS_ARN", "DISABLED")

ACCOUNT_NAME = os.environ.get("AWS_ACCOUNT_NAME", None)

# It seems that the sparkline symbols don't line up (probably based on font?)
# so put them last
# Also, leaving out the full block because Slack doesn't like it: '█'
sparks = ["▁", "▂", "▃", "▄", "▅", "▆", "▇"]

emojis = {
    "slack": {
        "good": ":white_check_mark:",
        "bad": ":warning:",
        "ugly": ":rotating_light:",
    },
    "teams": {
        # https://apps.timwhitlock.info/emoji/tables/unicode
        "good": "&#x2705;",  # green checkmark box
        "bad": "&#x1F514;",  # bell
        "ugly": "&#x1F525;",  # fire
    },
}


def get_account_name():
    account_name = ACCOUNT_NAME

    # Get account name from env, or account id/account alias from boto3
    if account_name is None:
        iam = boto3.client("iam")
        paginator = iam.get_paginator("list_account_aliases")
        for aliases in paginator.paginate(PaginationConfig={"MaxItems": 1}):
            if "AccountAliases" in aliases and len(aliases["AccountAliases"]) > 0:
                account_name = aliases["AccountAliases"][0]

    if account_name is None:
        account_name = boto3.client("sts").get_caller_identity().get("Account")

    if account_name is None:
        account_name = "[NOT FOUND]"

    return account_name


def get_days(yesterday):
    if yesterday is None:
        yesterday = datetime.datetime.today() - datetime.timedelta(days=1)
        today = datetime.date.today().strftime("%Y-%m-%d")
    else:
        yesterday = datetime.datetime.strptime(yesterday, "%Y-%m-%d")
        today = (datetime.datetime.today() + datetime.timedelta(days=1)).strftime(
            "%Y-%m-%d"
        )

    week_ago = yesterday - datetime.timedelta(days=n_days)

    return yesterday, today, week_ago


def get_result(result, today, week_ago):

    client = boto3.client("ce")
    query = {
        "TimePeriod": {
            "Start": week_ago.strftime("%Y-%m-%d"),
            "End": today,  # Yesterday will not be included if end isn't today.
        },
        "Granularity": "DAILY",
        "Filter": {
            "Not": {
                "Dimensions": {
                    "Key": "RECORD_TYPE",
                    "Values": ["Credit", "Refund", "Upfront", "Support", "Tax"],
                }
            }
        },
        "Metrics": ["UnblendedCost"],
        "GroupBy": [
            {
                "Type": "DIMENSION",
                "Key": "SERVICE",
            },
        ],
    }

    # Only run the query when on lambda, not when testing locally with example json
    if result is None:
        result = client.get_cost_and_usage(**query)

    return result


def sparkline(datapoints):
    """
    Pretty graph formatting for datapoints.
    :param datapoints: The datapoints to be formatted.
    :return: Formatted line
    """

    lower = min(datapoints)
    upper = max(datapoints)
    width = upper - lower
    n_sparks = len(sparks) - 1

    line = ""
    for dp in datapoints:
        scaled = 1 if width == 0 else (dp - lower) / width
        which_spark = int(scaled * n_sparks)
        line += sparks[which_spark]

    return line


def delta(costs):
    """
    Calculate delta on passed costs.
    :param costs: The cost data that requires a delta calculated.
    :return: Returns the delta for the costs.
    """

    if len(costs) > 1 and costs[-1] >= 1 and costs[-2] >= 1:
        # This only handles positive numbers
        result = ((costs[-1] / costs[-2]) - 1) * 100.0
    else:
        result = 0

    return result


# flake8: noqa: C901
def report_cost(
    event, context, result: dict = None, yesterday: str = None, new_method=True
):
    """
    Lambda handler, handles all processing for cost notifier.
    :param event: Unused
    :param context: Unused
    :param result: Determine if Cost Explorer should be queried for a result or not.
    :param yesterday: Stipulate the yesterday date you would like to run against.
    :param new_method: Stipulate if the new method of service array
        creation should be used.
    :return: cost_per_day_by_service: returned for local assert validation.
        Contains all aws costs by service.
    """

    yesterday, today, week_ago = get_days(yesterday)

    # Generate list of dates, so that even if our data is sparse,
    # we have the correct length lists of costs (len is n_days)
    list_of_dates = [
        (week_ago + datetime.timedelta(days=x)).strftime("%Y-%m-%d")
        for x in range(n_days + 1)
        # Include yesterday in the list of days + 1
    ]
    logging.debug("report_cost, date list for processing: " f"'{list_of_dates}'.")

    account_name = get_account_name()

    result = get_result(result, today, week_ago)

    cost_per_day_by_service = defaultdict(list)

    if not new_method:
        # Build a map of service -> array of daily costs for the time frame
        for day in result["ResultsByTime"]:
            for group in day["Groups"]:
                key = group["Keys"][0]
                cost = float(group["Metrics"]["UnblendedCost"]["Amount"])
                cost_per_day_by_service[key].append(cost)
    else:

        # New method, which first creates a dict of dicts
        # then loop over the services and loop over the list_of_dates
        # and this means even for sparse data we get a full list of costs
        cost_per_day_dict = defaultdict(dict)

        for day in result["ResultsByTime"]:
            start_date = day["TimePeriod"]["Start"]
            for group in day["Groups"]:
                key = group["Keys"][0]
                cost = float(group["Metrics"]["UnblendedCost"]["Amount"])
                cost_per_day_dict[key][start_date] = cost

        for key in cost_per_day_dict.keys():
            for start_date in list_of_dates:
                cost = cost_per_day_dict[key].get(
                    start_date, 0.0
                )  # fallback for sparse data
                cost_per_day_by_service[key].append(cost)

    logger.info(f"report_cost, cost per day: '{cost_per_day_by_service}'.")

    # Sort the map by yesterday's cost
    most_expensive_yesterday = sorted(
        cost_per_day_by_service.items(), key=lambda i: i[1][-1], reverse=True
    )

    service_names = [k for k, _ in most_expensive_yesterday[:5]]
    longest_name_len = len(max(service_names, key=len))

    buffer = f"{'Service':{longest_name_len}} ${'Yday':8} {'∆%':>5} {'Last 7d':7}\n"

    for service_name, costs in most_expensive_yesterday[:5]:
        buffer += (
            f"{service_name:{longest_name_len}}"
            f" ${costs[-1]:8,.2f} {delta(costs):4.0f}%"
            f" {sparkline(costs):7}\n"
        )

    other_costs = [0.0] * (n_days + 1)
    # Index is +1 larger than n_days as it includes yesterday. 0 - 7
    for service_name, costs in most_expensive_yesterday[5:]:
        for i, cost in enumerate(costs):
            other_costs[i] += cost

    buffer += (
        f"{'Other':{longest_name_len}}"
        f" ${other_costs[-1]:8,.2f} {delta(other_costs):4.0f}%"
        f" {sparkline(other_costs):7}\n"
    )

    total_costs = [0.0] * (n_days + 1)
    for day_number in range(n_days + 1):
        for service_name, costs in most_expensive_yesterday:
            try:
                total_costs[day_number] += costs[day_number]
            except IndexError:
                total_costs[day_number] += 0.0

    buffer += (
        f"{'Total':{longest_name_len}}"
        f" ${total_costs[-1]:8,.2f} {delta(total_costs):4.0f}%"
        f" {sparkline(total_costs):7}\n"
    )

    cost_per_day_by_service["total"] = total_costs[-1]

    emoji = emojis[WEBHOOK_TYPE]["good"]
    notify = ""
    if delta(total_costs) > AMBER_THRESHOLD:
        emoji = emojis[WEBHOOK_TYPE]["bad"]
        notify = "<!channel>\n"
    if delta(total_costs) > RED_THRESHOLD:
        emoji = emojis[WEBHOOK_TYPE]["ugly"]
        notify = "<!channel>\n"

    if WEBHOOK_TYPE == "teams":
        notify = ""  # Teams does not support @mention via webhooks yet.

    summary = (
        f"{emoji} {yesterday.strftime('%Y-%m-%d')}"
        f" cost for account {account_name}"
        f" was ${total_costs[-1]:,.2f}"
        f" {emoji} \n {notify}"
    )

    # Send emails
    if TOPIC_ARN != "DISABLED":
        sns_client = boto3.client("sns")
        sns_client.publish(
            TopicArn=TOPIC_ARN,
            Message=summary + str("\n\n" + buffer + "\n"),
            Subject="AWS Daily Cost Notifications",
        )

    # Send notifications
    for url in WEBHOOK_URLS:
        resp = requests.post(
            url,
            json={
                "text": summary + "\n\n```\n" + buffer + "\n```",
            },
        )

        if resp.status_code != 200:
            print("HTTP %s: %s" % (resp.status_code, resp.text))

    if TOPIC_ARN == "DISABLED" and len(WEBHOOK_URLS) == 0:
        print(summary)
        print(buffer)

    # for running locally to test output
    return cost_per_day_by_service


if __name__ == "__main__":
    """
    Run if local.
    """

    cost_per_day_by_service = report_cost(
        None, None, None, yesterday="2022-08-01", new_method=True
    )
    print(cost_per_day_by_service)
