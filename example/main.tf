module "billing_notifier_account_1" {
  source = "../"

  naming_prefix     = local.naming_prefix
  slack_webhook_url = "https://hooks.slack.com/services/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"
  account_name      = "pattern_demo"
}