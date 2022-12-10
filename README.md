# AWS Cost Notification Module

### Purpose

This terraform module sends a daily cost report and the cost delta in a 7 day rolling period, scheduled on a CRON to a slack or teams channel of your choice. The module also reports on the top 5 services attributing to the daily cost. Its a very rudamentary means of managing the cost of your AWS bill, but it does provide a 1000 ft view of the current expenses for the previous day. More on this module can be found on our [blog](https://medium.com/cloudandthings/aws-cost-notifier-e437bd311c54) on Medium.

### Parameters

| Parameter | Description|
| ----------| -----------|
| `naming_prefix` | Naming prefix given to the lambda |
| `webhook_url` | The Slack/Teams URL of the channel where the alert should be published |
| `account_name` | The display name given to the account. This friendly name will display in the alert |
| `notifcation_schedule` | CRON expression to schedule notification |
| `emails_for_notifications` | The list of email addresses where the alerts should be published |

### Examples

```
module "billing_notifier_root_account_slack" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix        = local.naming_prefix
  webhook_url    = "https://api.slack.com/messaging/webhooks" // slack webhook
  account_name         = "cloudandthings - master"
  notifcation_schedule = "cron(0 7 ? * MON-FRI *)"

}

module "billing_notifier_root_account_teams" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix        = local.naming_prefix
  webhook_url    = "https://cloudandthingsio.webhook.office.com/webhookb2/xxx/IncomingWebhook/xxxxxx" // teams webhook
  account_name         = "cloudandthings - master"
  notifcation_schedule = "cron(0 20 * * ? *)"

}

module "billing_notifier_root_account_emails" {
  source = "github.com/cloudandthings/terraform-aws-costnotifier"

  naming_prefix        = local.naming_prefix
  slack_webhook_url    = "https://api.slack.com/messaging/webhooks"
  account_name         = "cloudandthings - master"
  notifcation_schedule = "cron(0 20 * * ? *)"
  emails_for_notifications = ["velisa@cat.io", "adan@cat.io"]  // Optional

}
```

Project Road Map:
- [x] Simple means to notify owners of their AWS account cost
- [x] Email integration or other ChatOps tools. Slack and Teams supported
- [x] Enable users to further customise parameters like the CloudWatch Rule

<!-- BEGIN_TF_DOCS -->
### Examples

Select an example from the dropdown menu above.

----
## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | (required) Name of your account to Identify your account in the notification message | `string` | n/a | yes |
| <a name="input_amber_threshold"></a> [amber\_threshold](#input\_amber\_threshold) | Percentage exceeded threshold to send an amber alert and notify the slack channel | `string` | `"20"` | no |
| <a name="input_emails_for_notifications"></a> [emails\_for\_notifications](#input\_emails\_for\_notifications) | List of emails to receive cost notifier notifications | `list(string)` | `[]` | no |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | (required) Naming prefix used to name all resources | `string` | n/a | yes |
| <a name="input_notification_schedule"></a> [notification\_schedule](#input\_notification\_schedule) | (optional) CRON expression to schedule notification | `string` | `"cron(0 20 ? * MON-SUN *)"` | no |
| <a name="input_red_threshold"></a> [red\_threshold](#input\_red\_threshold) | Percentage exceeded threshold to send a red alert and notify the slack channel | `string` | `"50"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | (optional) List of VPC security group IDs associated with the Lambda function. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (optional) List of VPC subnet IDs associated with the Lambda function. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (optional) A mapping of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_webhook_urls"></a> [webhook\_urls](#input\_webhook\_urls) | (required) Webhook URLs to receive daily cost notifications on either Slack or Teams | `list(string)` | n/a | yes |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_notifier_lambda"></a> [billing\_notifier\_lambda](#module\_billing\_notifier\_lambda) | nozaq/lambda-auto-package/aws | 0.2.0 |

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cost_notfier_lambda_name"></a> [cost\_notfier\_lambda\_name](#output\_cost\_notfier\_lambda\_name) | Created lambda's name |

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |

----
### Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.billing_notifier_lambda_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.cost_explorer_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_lambda_permission.billing_notifier_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.cost_notifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.cost_notifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

----
<!-- END_TF_DOCS -->
