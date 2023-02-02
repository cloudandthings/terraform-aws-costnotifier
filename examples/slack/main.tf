module "example" {

  # Update source and version as needed.
  source = "../../"

  naming_prefix = "costnotifier-example-slack"
  account_name  = "cloudandthings - master"

  webhook_urls = ["https://hooks.slack.com"] # slack webhook
  webhook_type = "slack"

  notification_schedule = "cron(0 7 ? * MON-FRI *)"
}
