variable "project" {
  type = string
}
variable "environment" {
  description = "Environment"
  type        = string
}

variable "owner" {
  type = string
}

variable "purpose" {
  type = string
}

variable "enable_versioning" {
  type = bool
}
variable "readonly_user_arns" {
  description = "List of IAM user/role ARNs with read-only access"
  type        = list(string)
  default     = []
}
variable "admin_role_arn" {
  description = "IAM role ARN with full admin access (null = no admin policy added)"
  type        = string
  default     = null
}

variable "noncurrent_version_expiry_days" {
  description = "Days before old versions are deleted (only used if versioning is enabled)"
  type        = number
  default     = 90
}
