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

variable "notification_schedule" {
  type        = string
  description = "(optional) CRON expression to schedule notification"
  default     = "cron(0 20 ? * MON-SUN *)"
}

variable "emails_for_notifications" {
  type        = list(string)
  description = "List of emails to receive cost notifier notifications"
  default     = []
}

variable "amber_threshold" {
  type        = string
  description = "Percentage exceeded threshold to send an amber alert and notify the slack channel"
  default     = "20"
}

variable "red_threshold" {
  type        = string
  description = "Percentage exceeded threshold to send a red alert and notify the slack channel"
  default     = "50"
}

variable "security_group_ids" {
  description = "(optional) List of VPC security group IDs associated with the Lambda function."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "(optional) List of VPC subnet IDs associated with the Lambda function."
  type        = list(string)
  default     = []
}
