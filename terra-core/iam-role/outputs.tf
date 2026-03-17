# ─── Outputs ──────────────────────────────────────────────────────────────────
output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}

output "instance_profile_arn" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this[0].arn : null
}

output "instance_profile_name" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}
