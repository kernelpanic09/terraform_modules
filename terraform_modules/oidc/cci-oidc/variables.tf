variable "cci_aws_audience" {
  description = "The audience value to use with run identity tokens"
  type        = string
  default     = "aws.workload.identity"
}

variable "cci_hostname" {
  description = "The hostname of the CircleCi instance you are integrating with AWS"
  type        = string
  default     = "oidc.circleci.com"
}

variable "cci_org_id" {
  description = "The GUID value representing the CircleCi Org ID"
  type        = string
  default     = "org_string_id"
}

variable "cci_role_name" {
  description = "String name of IAM role for CircleCi OIDC operations"
  default     = "circleci-svcrole-oidc"
  type        = string
}

variable "cci_run_role_policy_arn" {
  description = "ARN of an IAM policy to be used for OIDC user context"
  type        = string
  default     = "arn:aws:iam::aws:policy/PowerUserAccess"
}
