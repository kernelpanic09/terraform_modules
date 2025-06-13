output "aws_run_role_arn" {
  value       = aws_iam_role.tfc_role.arn
  description = "The ARN value of the IAM role created for use in OIDC transactions against AWS."
}

output "aws_tfc_idp_arn" {
  description = "The ARN value of the Identity Provider used by Terraform Cloud."
  value       = aws_iam_openid_connect_provider.tfc_provider.arn
}
