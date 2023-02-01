locals {
  policy_statements = merge({
    ce_permissions = {
      effect = "Allow"
      actions = [
        "ce:GetCostAndUsage",
        "iam:ListAccountAliases"
      ]
      resources = ["*"]
    }
    },
    local.no_of_emails != 0 ? {
      sns_permissions = {
        effect = "Allow"
        actions = [
          "sns:Publish"
        ]
        resources = [for aws_sns_topic in aws_sns_topic.cost_notifier : aws_sns_topic.arn]
      }
    } : {}
  )
}
