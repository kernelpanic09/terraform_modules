variable "tfc_aws_audience" {
  description = "The audience value to use with run identity tokens"
  type        = string
  default     = "aws.workload.identity"
}

variable "tfc_hostname" {
  description = "The hostname of the TFC or TFE instance you are integrating with AWS"
  type        = string
  default     = "app.terraform.io"
}

variable "tfc_role_name" {
  description = "String name of IAM role for TFC OIDC operations"
  default     = "terraform-svcrole-oidc"
  type        = string
}

variable "tfc_run_role_policy_arn" {
  description = "String name of IAM policy for OIDC user context"
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
  type        = string
}

variable "tfc_org_name" {
  type        = string
  description = "The organizational name of Org within Terrafom Cloud"
  default     = "orgname"
}
