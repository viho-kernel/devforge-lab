module "developer_readonly_role" {
  source           = "./iam-role"
  project          = var.project
  environment      = var.environment
  owner            = var.owner
  role_name        = "developer-readonly"
  role_description = "Read only acess for developers to view infrastructure"

  trusted_arns = [
    "arn:aws:iam::992989046853:user/ansible-user",
    "arn:aws:iam::992989046853:user/joindevops"
  ]
  policy_statements = [
    {
      Sid    = "AllowReadOnlyAccess"
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "ec2:Describe*",
        "iam:Get*",
        "iam:List*"
      ]
      Resource = "*"
    }
  ]
}

module "ec2_instance_role" {
  source = "./iam-role"

  project          = var.project
  environment      = var.environment
  role_name        = "ec2-instance"
  owner            = var.owner
  role_description = "Role attached to EC2 instances for AWS service access"

  trusted_arns = [
    "arn:aws:iam::992989046853:root"
  ]

  create_instance_profile = true

  policy_statements = [
    {
      Sid    = "AllowS3ReadAccess"
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::devforge-lab-dev-backend-bucket",
        "arn:aws:s3:::devforge-lab-dev-backend-bucket/*"
      ]
    },
    {
      Sid    = "AllowSSMAccess"
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssmmessages:*",
        "ssm:UpdateInstanceInformation"
      ]
      Resource = "*"
    },
    {
      Sid    = "AllowCloudWatchLogs"
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }
  ]


}
