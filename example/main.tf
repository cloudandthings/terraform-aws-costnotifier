module "billing_notifier_account_1" {
  source = "../"

  naming_prefix     = local.naming_prefix
  slack_webhook_url = "https://api.slack.com/messaging/webhooks"
  account_name      = "cloudandthings - master"
}