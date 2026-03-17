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

  create_instance_profile = true


}
