locals {
  emails       = var.emails_for_notifications
  no_of_emails = length(local.emails)

  sns_encryption_key_id    = var.encryption_key_id == null ? "alias/aws/sns" : var.encryption_key_id
  lambda_encryption_key_id = var.encryption_key_id == null ? "alias/aws/lambda" : var.encryption_key_id
}

resource "aws_sns_topic" "cost_notifier" {
  count = local.no_of_emails != 0 ? 1 : 0
  name  = "${var.naming_prefix}-costnotifier"

  kms_master_key_id = local.sns_encryption_key_id
}

resource "aws_sns_topic_subscription" "cost_notifier" {
  count = local.no_of_emails != 0 ? local.no_of_emails : 0

  topic_arn = aws_sns_topic.cost_notifier[0].arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}
