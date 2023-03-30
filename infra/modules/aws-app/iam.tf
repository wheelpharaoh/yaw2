resource "aws_iam_role" "this" {
  name                  = "${local.prefix}-role"
  force_detach_policies = true
  managed_policy_arns   = [aws_iam_policy.this.arn]
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags                  = local.tags
}

resource "aws_iam_policy" "this" {
  name = "${local.prefix}-${var.branch}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:*",
          "ssmmessages:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = local.tags
}



resource "aws_iam_instance_profile" "this" {
  name = "${local.prefix}-${var.branch}-inst-profile"
  role = aws_iam_role.this.name
  tags = local.tags
}
