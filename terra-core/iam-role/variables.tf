variable "project" {
  description = "project name"
  type        = string
}

variable "owner" {
  description = "Owner performing changes"
  type        = string

}
variable "environment" {
  description = "Environment"
  type        = string
}

variable "role_name" {
  description = "role name"
  type        = string
}

variable "role_description" {
  description = "what is this role"
  type        = string
}

variable "trusted_arns" {
  type = list(string)
}

variable "policy_statements" {
  description = "IAM Policy statements"
  type        = any
  default     = []
}
variable "create_instance_profile" {
  description = "Set true only for EC2 roles"
  type        = bool
  default     = false
}
