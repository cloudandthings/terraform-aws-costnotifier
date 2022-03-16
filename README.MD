# AWS Cost Notification Module

### Purpose

This terraform module sends a daily cost report and the delta in a 7 day rolling period at 8 PM UTC to a slack channel of your choice. The module also reports on the top 5 services attributing to the daily cost. Its a very rudamentary means of managing the cost of your AWS bill, but it does provide a 1000 ft view of the current expenses for the previous day. More on this module can be found on our [blog](https://medium.com/cloudandthings/aws-cost-notifier-e437bd311c54) on Medium.

### Parameters

| Parameter | Description|
| ----------| -----------|
| `naming_prefix` | Naming prefix given to the lambda |
| `slack_webhook_url` | The Slack URL of the channel where the alert should be published |
| `account_name` | The display name given to the account. This friendly name will display in the alert |

### Example

```
module "billing_notifier_root_account" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix     = local.naming_prefix
  slack_webhook_url = "https://api.slack.com/messaging/webhooks"
  account_name      = "cloudandthings - master"

}
```

Project Road Map:
- [x] Simple means to notify owners of their AWS account cost
- [ ] Email integration or other ChatOps tools
- [ ] Enable users to further customise parameters like the CloudWatch Rule