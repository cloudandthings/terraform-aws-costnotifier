module "billing_notifier_root_account_teams" {

  # Update source and version as needed.
  source = "../../"

  naming_prefix = "costnotifier-example-teams"
  account_name  = "cloudandthings - master"

  webhook_urls = ["https://cloudandthingsio.webhook.office.com/webhookb2/xxx/IncomingWebhook/xxxxxx"] # teams webhook

  notification_schedule = "cron(0 20 * * ? *)"

}
