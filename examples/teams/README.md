<!-- BEGIN_TF_DOCS -->
----
## main.tf
```hcl
module "billing_notifier_root_account_teams" {

  # Update source and version as needed.
  source = "../../"

  naming_prefix = "costnotifier-example-teams"
  account_name  = "cloudandthings - master"

  webhook_urls = ["https://cloudandthingsio.webhook.office.com/webhookb2/xxx/IncomingWebhook/xxxxxx"] # teams webhook
  webhook_type = "teams"

  notification_schedule = "cron(0 20 * * ? *)"
}
```
----

## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `null` | no |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_notifier_root_account_teams"></a> [billing\_notifier\_root\_account\_teams](#module\_billing\_notifier\_root\_account\_teams) | ../../ | n/a |

----
### Outputs

No outputs.

----
### Providers

No providers.

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |

----
### Resources

No resources.

----
<!-- END_TF_DOCS -->
