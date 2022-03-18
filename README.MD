# AWS Cost Notification Module

### Purpose

This terraform module sends a daily cost report and the cost delta in a 7 day rolling period, scheduled on a CRON to a slack or teams channel of your choice. The module also reports on the top 5 services attributing to the daily cost. Its a very rudamentary means of managing the cost of your AWS bill, but it does provide a 1000 ft view of the current expenses for the previous day. More on this module can be found on our [blog](https://medium.com/cloudandthings/aws-cost-notifier-e437bd311c54) on Medium.

### Parameters

| Parameter | Description|
| ----------| -----------|
| `naming_prefix` | Naming prefix given to the lambda |
| `slack_webhook_url` | The Slack URL of the channel where the alert should be published |
| `account_name` | The display name given to the account. This friendly name will display in the alert |
| `notifcation_schedule` | CRON expression to schedule notification |

### Example

```
module "billing_notifier_root_account_slack" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix        = local.naming_prefix
  slack_webhook_url    = "https://api.slack.com/messaging/webhooks"
  account_name         = "cloudandthings - master"
  notifcation_schedule = "cron(0 7 ? * MON-FRI *)"

}

module "billing_notifier_root_account_teams" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix        = local.naming_prefix
  slack_webhook_url    = "https://cloudandthingsio.webhook.office.com/webhookb2/xxx/IncomingWebhook/xxxxxx"
  account_name         = "cloudandthings - master"
  notifcation_schedule = "cron(0 20 * * ? *)"

}
```

Project Road Map:
- [x] Simple means to notify owners of their AWS account cost
- [x] Email integration or other ChatOps tools. Slack and Teams supported
- [x] Enable users to further customise parameters like the CloudWatch Rule