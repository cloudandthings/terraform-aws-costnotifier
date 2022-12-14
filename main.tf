resource "aws_cloudwatch_event_rule" "billing_notifier_lambda_event_rule" {
  schedule_expression = var.notification_schedule
}

resource "aws_cloudwatch_event_target" "billing_notifier_lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.name
  target_id = "check-non-compliant-report-event-rule"
  arn       = module.billing_notifier_lambda.lambda_function.arn
  depends_on = [
    module.billing_notifier_lambda
  ]
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "billing_notifier_lambda_permission" {
  function_name = module.billing_notifier_lambda.lambda_function.function_name

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
  vpc_config = (
    length(var.security_group_ids) + length(var.subnet_ids) == 0
    ? null
    : {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  )

}

#tfsec:ignore:aws-lambda-enable-tracing
module "billing_notifier_lambda" {

  # Temporary until this is merged:
  # https://github.com/nozaq/terraform-aws-lambda-auto-package/pull/30
  source = "./modules/external/nozaq/lambda-auto-package"
  # source  = "nozaq/lambda-auto-package/aws"
  # version = "0.4.0"

  ####################################
  # General
  function_name = var.naming_prefix
  description   = var.lambda_description

  handler = "handler.report_cost"
  runtime = "python3.7"

  timeout = 300
  tags    = var.tags

  ####################################
  # Build

  output_path = "${path.module}/billing-notifier/package.zip"

  source_dir = var.enable_remote_build ? "${path.module}/billing-notifier/" : null

  build_command = var.enable_remote_build ? "${path.module}/billing-notifier/pip.sh ${path.module}/billing-notifier" : ""

  build_triggers = {
    requirements = base64sha256(file("${path.module}/billing-notifier/requirements.txt"))
    execute      = base64sha256(file("${path.module}/billing-notifier/pip.sh"))
  }

  ####################################
  # KMS

  # The ARN of the KMS Key to use when encrypting log data.
  kms_key_id = var.kms_key_arn
  # The ARN of the KMS Key to use when encrypting environment variables.
  # Ignored unless `environment` is specified.
  lambda_kms_key_arn = var.kms_key_arn

  ####################################
  # IAM
  iam_role_name_prefix = var.naming_prefix

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSCostAndUsageReportAutomationPolicy",
    aws_iam_policy.cost_explorer_access_policy.arn
  ]

  permissions_boundary = var.permissions_boundary

  ####################################
  # Environment
  environment = {
    variables = {
      WEBHOOK_URLS     = jsonencode(var.webhook_urls)
      WEBHOOK_TYPE     = lower(var.webhook_type)
      AWS_ACCOUNT_NAME = var.account_name
      SNS_ARN          = local.no_of_emails != 0 ? aws_sns_topic.cost_notifier[0].arn : "DISABLED"
      AMBER_THRESHOLD  = var.amber_threshold
      RED_THRESHOLD    = var.red_threshold
    }
  }

  ####################################
  # Network
  vpc_config = local.vpc_config
}
