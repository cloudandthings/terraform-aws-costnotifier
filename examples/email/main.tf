module "example" {

  # Update source and version as needed.
  # TODO why cant conftest do this?
  source = "../../"

  naming_prefix = "costnotifier-example-email"
  account_name  = "cloudandthings - master"

  webhook_urls          = ["https://api.slack.com/messaging/webhooks"]
  notification_schedule = "cron(0 20 * * ? *)"

  emails_for_notifications = ["velisa@cat.io", "adan@cat.io"] # Optional

}
