module "constants" {
  source = "../../constants"
}

module "billing_notifier_account_1" {
  source = "../"

  naming_prefix = local.constants.naming_prefix
  webhook_url   = ["https://api.slack.com/messaging/webhooks"]
  account_name  = "cloudandthings - master"
}
