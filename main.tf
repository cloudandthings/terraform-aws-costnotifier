resource "aws_cloudwatch_event_rule" "billing_notifier_lambda_event_rule" {
  schedule_expression = var.notification_schedule
}

resource "aws_cloudwatch_event_target" "billing_notifier_lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.name
  target_id = "check-non-compliant-report-event-rule"
  arn       = module.billing_notifier_lambda.lambda_function_arn
  depends_on = [
    module.billing_notifier_lambda
  ]
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "billing_notifier_lambda_permission" {
  function_name = module.billing_notifier_lambda.lambda_function_name

  statement_id = "AllowExecutionFromCloudWatch"
  action       = "lambda:InvokeFunction"
  principal    = "events.amazonaws.com"

  source_arn     = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.arn
  source_account = data.aws_caller_identity.current.account_id

  depends_on = [
    module.billing_notifier_lambda
  ]
}

locals {

  deployment_filename = "costnotifier-${var.runtime}.zip"
  deployment_path     = "${path.module}/${local.deployment_filename}"

  s3_key = coalesce(var.s3_key, join("/", [var.naming_prefix, local.deployment_filename]))
}

resource "aws_s3_object" "deployment" {
  count  = var.upload_deployment_to_s3 ? 1 : 0
  bucket = var.s3_bucket
  key    = local.s3_key
  source = local.deployment_path

  etag = filemd5(local.deployment_path)
}

#tfsec:ignore:aws-lambda-enable-tracing
module "billing_notifier_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.9.0"

  function_name = var.naming_prefix
  description   = var.lambda_description

  handler = "app.lambda_handler"
  runtime = var.runtime
  timeout = 300

  create_package         = false
  local_existing_package = local.deployment_path

  s3_existing_package = (
    var.s3_bucket != null
    ? {
      bucket = var.s3_bucket
      key    = local.s3_key
    }
    : null
  )

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  cloudwatch_logs_kms_key_id        = var.kms_key_arn
  kms_key_arn                       = var.kms_key_arn

  # IAM
  create_role              = var.create_role
  attach_policy_statements = var.create_role

  lambda_role               = var.lambda_role
  role_permissions_boundary = var.permissions_boundary
  role_name                 = var.naming_prefix
  role_description          = "Role used for the AWS Cost Notifier"
  policy_statements         = local.policy_statements

  # Networking
  vpc_security_group_ids = var.security_group_ids
  vpc_subnet_ids         = var.subnet_ids

  environment_variables = {
    WEBHOOK_URLS     = jsonencode(var.webhook_urls)
    WEBHOOK_TYPE     = lower(var.webhook_type)
    AWS_ACCOUNT_NAME = var.account_name
    SNS_ARN          = local.no_of_emails != 0 ? aws_sns_topic.cost_notifier[0].arn : "DISABLED"
    AMBER_THRESHOLD  = var.amber_threshold
    RED_THRESHOLD    = var.red_threshold
  }

  tags = var.tags

  create_lambda_function_url = false

}
