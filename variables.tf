variable "naming_prefix" {
  type        = string
  description = "Naming prefix used to name all resources"
}

#---------------------------------------------------------------------------------------------------
# Notifications
#---------------------------------------------------------------------------------------------------

variable "account_name" {
  type        = string
  description = "Name of your account to Identify your account in the notification message"
}

variable "notification_schedule" {
  type        = string
  description = "CRON expression to schedule notification"
  default     = "cron(0 20 ? * MON-SUN *)"
}

variable "webhook_urls" {
  type        = list(string)
  description = "Webhook URLs to receive daily cost notifications on either Slack or Teams"
}

variable "emails_for_notifications" {
  type        = list(string)
  description = "List of emails to receive cost notifier notifications"
  default     = []
}

#---------------------------------------------------------------------------------------------------
# Thresholds
#---------------------------------------------------------------------------------------------------

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

#---------------------------------------------------------------------------------------------------
# IAM
#---------------------------------------------------------------------------------------------------

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = null
}

#---------------------------------------------------------------------------------------------------
# Network
#---------------------------------------------------------------------------------------------------

variable "security_group_ids" {
  description = "List of VPC security group IDs associated with the Lambda function."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs associated with the Lambda function."
  type        = list(string)
  default     = []
}

#---------------------------------------------------------------------------------------------------
# KMS
#---------------------------------------------------------------------------------------------------

variable "sns_topic_kms_key_arn" {
  description = "KMS key ARN to use for encrypting SNS topic"
  type        = string
  default     = "alias/aws/sns"
}
