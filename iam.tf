resource "aws_iam_policy" "cost_explorer_access_policy" {
  name        = "cost-report-policy"
  path        = "/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ce:*"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  })
}