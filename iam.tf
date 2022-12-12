resource "aws_iam_policy" "cost_explorer_access_policy" {
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Effect = "Allow"
        Action = [
          "ce:GetCostAndUsage"
        ],
        Resource = "*"
      }],
      [for aws_sns_topic in aws_sns_topic.cost_notifier :
        {
          Effect = "Allow"
          Action = [
            "sns:Publish"
          ]
          Resource = aws_sns_topic.arn
      }]
    )
  })

  tags = var.tags
}
