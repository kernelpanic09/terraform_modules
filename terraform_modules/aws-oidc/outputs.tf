output "aws_run_role_arn" {
  value       = toset([for arn in aws_iam_role.aws_role : arn.arn])
  description = "The ARN value of the IAM role created for use in OIDC transactions against AWS."
}

output "aws_tfc_idp_arn" {
  description = "The ARN value of the Identity Provider used by Terraform Cloud."
  value       = var.aws_config ? aws_iam_openid_connect_provider.aws_identity_provider[*].arn : null
}

output "cci_run_role_arn" {
  description = "AWS ARN value representing the CircleCI user context used to drive jobs."
  value       = aws_iam_role.cci_role[*].arn
}

output "cci_aws_idp_arn" {
  description = "The ARN value of the Identity Provider used by CircleCI."
  value       = aws_iam_openid_connect_provider.cci_provider[*].arn
}
