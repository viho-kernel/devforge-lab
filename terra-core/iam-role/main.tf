resource "aws_iam_role" "this" {
  name        = "${var.project}-${var.environment}-${var.role_name}"
  description = var.role_description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_arns
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags
    , {
      Name = "${var.project}-${var.environment}-${var.role_name}"
  })
}

resource "aws_iam_policy" "this" {
  name        = "${var.project}-${var.environment}-${var.role_name}-policy"
  description = "Policy for ${var.role_name}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.policy_statements
  })

  tags = merge(local.common_tags, {
    Name      = "${var.project}-${var.environment}-${var.role_name}-policy"
    ManagedBy = "terraform"
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.project}-${var.environment}-${var.role_name}-profile"
  role  = aws_iam_role.this.name

  tags = merge(local.common_tags
    , {
      Name      = "${var.project}-${var.environment}-${var.role_name}-profile"
      ManagedBy = "terraform"
  })
}
