# AWS Cost Notification Module

### Purpose

This terraform module sends a daily cost report and the cost delta in a 7 day rolling period, scheduled on a CRON to a slack or teams channel of your choice.

The module also reports on the top 5 services attributing to the daily cost. Its a very rudimentary means of managing the cost of your AWS bill, but it does provide a 1000 ft view of the current expenses for the previous day. More on this module can be found on our [blog](https://medium.com/cloudandthings/aws-cost-notifier-e437bd311c54) on Medium.

### Lambda deployment package

The Lambda function is deployed using a `.zip` deployment package. The package is contained within this module and also attached to the GitHub release.

You may choose one of the following options for the deployment:

 1. **default:** If no `s3_*` variables are specified, then the package is used by the lambda directly.
 2. **recommended**: `s3_bucket` can be specified to upload the package to the S3 bucket, for the lambda to use.
    - `s3_prefix` can be specified to override the default location.
    - `upload_deployment_to_s3=false` can be specified to disable the upload, in which case the package must be placed on s3 manually.


<!-- BEGIN_TF_DOCS -->
### Examples

See `examples` dropdown on Terraform Cloud, or [browse here](/examples/).

----
## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | Name of your account to Identify your account in the notification message | `string` | n/a | yes |
| <a name="input_amber_threshold"></a> [amber\_threshold](#input\_amber\_threshold) | Percentage exceeded threshold to send an amber alert and notify the slack channel | `string` | `"20"` | no |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `14` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Controls whether IAM role for Lambda Function should be created | `bool` | `true` | no |
| <a name="input_emails_for_notifications"></a> [emails\_for\_notifications](#input\_emails\_for\_notifications) | List of emails to receive cost notifier notifications | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The alias, alias ARN, key ID, or key ARN of an AWS KMS key used to encrypt all resources. | `string` | `null` | no |
| <a name="input_lambda_description"></a> [lambda\_description](#input\_lambda\_description) | Lambda function description. | `string` | `"This function sends AWS cost notifications. Source: github.com/cloudandthings/terraform-aws-costnotifier"` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details. | `string` | `""` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | The lambda runtime to use. One of: `["python3.9", "python3.8", "python3.7"]` | `string` | `"python3.8"` | no |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Naming prefix used to name all resources | `string` | n/a | yes |
| <a name="input_notification_schedule"></a> [notification\_schedule](#input\_notification\_schedule) | CRON expression to schedule notification | `string` | `"cron(0 20 ? * MON-SUN *)"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_red_threshold"></a> [red\_threshold](#input\_red\_threshold) | Percentage exceeded threshold to send a red alert and notify the slack channel | `string` | `"50"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket for deployment package. | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 object key for deployment package. Otherwise, defaults to `var.naming_prefix/local.deployment_filename`. | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of VPC security group IDs associated with the Lambda function. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC subnet IDs associated with the Lambda function. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_upload_deployment_to_s3"></a> [upload\_deployment\_to\_s3](#input\_upload\_deployment\_to\_s3) | If `true`, the deployment package within this module repo will be copied to S3. If `false` then the S3 object must be uploaded separately. Ignored if `s3_bucket` is null. | `bool` | `true` | no |
| <a name="input_webhook_type"></a> [webhook\_type](#input\_webhook\_type) | Either "slack" or "teams". | `string` | `"slack"` | no |
| <a name="input_webhook_urls"></a> [webhook\_urls](#input\_webhook\_urls) | Webhook URLs to receive daily cost notifications on either Slack or Teams | `list(string)` | n/a | yes |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_notifier_lambda"></a> [billing\_notifier\_lambda](#module\_billing\_notifier\_lambda) | terraform-aws-modules/lambda/aws | 4.9.0 |

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cost_notfier_lambda_name"></a> [cost\_notfier\_lambda\_name](#output\_cost\_notfier\_lambda\_name) | Created lambda's name |

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.9 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |

----
### Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.billing_notifier_lambda_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_lambda_permission.billing_notifier_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_object.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_sns_topic.cost_notifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.cost_notifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

----
<!-- END_TF_DOCS -->
