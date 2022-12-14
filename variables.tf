#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "Naming prefix used to name all resources"
}

variable "lambda_description" {
  description = "Lambda function description."
  type        = string
  default     = "This function sends AWS cost notifications. Source: github.com/cloudandthings/terraform-aws-costnotifier"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
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

variable "webhook_type" {
  description = "Either \"slack\" or \"teams\"."
  type        = string
  default     = "slack"
  validation {
    condition     = contains(["slack", "teams"], lower(var.webhook_type))
    error_message = "Must be one of: \"slack\", \"teams\"."
  }
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

variable "kms_key_arn" {
  description = "The alias, alias ARN, key ID, or key ARN of an AWS KMS key used to encrypt all resources."
  type        = string
  default     = null
}

#---------------------------------------------------------------------------------------------------
# Build
#---------------------------------------------------------------------------------------------------

variable "enable_remote_build" {
  description = "Whether to enable remote building for the lambda function package ardhive, otherwise a local copy of the archive is used."
  type        = bool
  default     = false
}
