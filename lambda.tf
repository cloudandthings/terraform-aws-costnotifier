resource "aws_cloudwatch_event_rule" "billing_notifier_lambda_event_rule" {
  name                = "everyday-8PM"
  schedule_expression = "cron(0 20 * * ? *)"
}

resource "aws_cloudwatch_event_target" "billing_notifier_lambda_event_target" {
  rule       = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.name
  target_id  = "check-non-compliant-report-event-rule"
  arn        = module.billing_notifier_lambda.lambda_function.arn
  depends_on = [
    module.billing_notifier_lambda
  ]
}

resource "aws_lambda_permission" "billing_notifier_lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.billing_notifier_lambda.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.billing_notifier_lambda_event_rule.arn
  depends_on    = [
    module.billing_notifier_lambda
  ]
}

module "billing_notifier_lambda" {
  source  = "nozaq/lambda-auto-package/aws"
  version = "0.2.0"
  
  source_dir  = "${path.module}/billing-notifier/"
  output_path = "${path.module}/packages/billing-notifier.zip"

  build_triggers = {
    requirements = "${base64sha256(file("${path.module}/billing-notifier/requirements.txt"))}"
    execute      = "${base64sha256(file("${path.module}/billing-notifier/pip.sh"))}"
  }
  build_command = "${path.module}/billing-notifier/pip.sh ${path.module}/billing-notifier"

  iam_role_name_prefix  = var.naming_prefix
  policy_arns           = [
                              "arn:aws:iam::aws:policy/service-role/AWSCostAndUsageReportAutomationPolicy",
                              "${aws_iam_policy.cost_explorer_access_policy.arn}"
                          ]
  function_name         = var.naming_prefix
  handler               = "handler.report_cost"
  runtime               = "python3.7"
  timeout               = 600

  environment = {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
      AWS_ACCOUNT_NAME  = var.account_name
    }
  }
}