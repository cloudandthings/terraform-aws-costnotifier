variable "naming_prefix" {
  type = string
  description = "(required) Naming prefix used to name all resources"
}

variable "webhook_url" {
  type = string
  description = "(required) Webhook URL to receive daily cost notifications on either Slack or Teams"
}

variable "account_name" {
  type = string
  description = "(required) Name of your account to Identify your account in the notification message"
}

variable "notifcation_schedule" {
  type = string
  description = "(optional) CRON expression to schedule alert"
  default = "cron(0 20 * * ? *)"
}