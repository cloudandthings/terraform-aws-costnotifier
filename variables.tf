variable "naming_prefix" {
  type        = string
  description = "(required) Naming prefix used to name all resources"
}

variable "webhook_urls" {
  type        = list(string)
  description = "(required) Webhook URLs to receive daily cost notifications on either Slack or Teams"
}

variable "account_name" {
  type        = string
  description = "(required) Name of your account to Identify your account in the notification message"
}

variable "notifcation_schedule" {
  type        = string
  description = "(optional) CRON expression to schedule notification"
  default     = "cron(0 7 ? * MON-SUN *)"
}

variable "emails_for_notifications" {
  type        = list(string)
  description = "List of emails to receive cost notifier notifications"
  default     = []
}
