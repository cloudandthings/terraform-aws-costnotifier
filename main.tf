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
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.billing_notifier_lambda.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.arn
  depends_on = [
    module.billing_notifier_lambda
  ]
  source_account = data.aws_caller_identity.current.account_id
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

  source  = "nozaq/lambda-auto-package/aws"
  version = "0.4.0"

  ####################################
  # General
  function_name = var.naming_prefix
  description   = var.lambda_description

  handler = "handler.report_cost"
  runtime = "python3.7"

  timeout = 300

  ####################################
  # Build
  source_dir  = "${path.module}/billing-notifier/"
  output_path = "${path.module}/packages/billing-notifier.zip"

  build_command = "${path.module}/billing-notifier/pip.sh ${path.module}/billing-notifier"
  build_triggers = {
    requirements = base64sha256(file("${path.module}/billing-notifier/requirements.txt"))
    execute      = base64sha256(file("${path.module}/billing-notifier/pip.sh"))
  }

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
      AWS_ACCOUNT_NAME = var.account_name
      SNS_ARN          = local.no_of_emails != 0 ? aws_sns_topic.cost_notifier[0].arn : "None"
      AMBER_THRESHOLD  = var.amber_threshold
      RED_THRESHOLD    = var.red_threshold
    }
  }

  ####################################
  # Network
  vpc_config = local.vpc_config
}
