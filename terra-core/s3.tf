module "bucket" {
  source                         = "./s3-bucket"
  project                        = var.project
  environment                    = var.environment
  owner                          = var.owner
  purpose                        = "backend"
  enable_versioning              = true
  noncurrent_version_expiry_days = 90
  readonly_user_arns = [
    "arn:aws:iam::992989046853:user/ansible-user",
    "arn:aws:iam::992989046853:user/joindevops",
  ]

  admin_role_arn = "arn:aws:iam::992989046853:role/terraform-admin"
}
