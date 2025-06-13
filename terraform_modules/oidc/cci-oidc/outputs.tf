output "cci_run_role_arn" {
  description = "AWS ARN value representing the CircleCI user context used to drive jobs."
  value       = aws_iam_role.cci_role.arn
}

output "cci_aws_idp_arn" {
  description = "The ARN value of the Identity Provider used by CircleCI."
  value       = aws_iam_openid_connect_provider.cci_provider.arn
}
