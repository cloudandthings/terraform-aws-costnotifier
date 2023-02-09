<!-- BEGIN_TF_DOCS -->
----
## main.tf
```hcl
module "example" {

  # Update source and version as needed.
  source = "../../"

  naming_prefix = "costnotifier-example-slack"
  account_name  = "cloudandthings - master"

  webhook_urls = ["https://hooks.slack.com"] # slack webhook
  webhook_type = "slack"

  notification_schedule = "cron(0 7 ? * MON-FRI *)"

  ### Uncomment to fetch the deployment package from S3
  # s3_bucket = "my_s3_bucket"
  ### Uncomment to upload the local deployment package to S3
  # upload_deployment_to_s3 = true
}
```
----

## Documentation

----
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"af-south-1"` | no |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../../ | n/a |

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
