variable "aws_config" {
  description = "Boolean toggle to enable/disable the deployment of OIDC resources for AWS authentication."
  type        = bool
  default     = true
}
variable "cci_config" {
  description = "Boolean toggle to enable/disable the deployment of OIDC resources for AWS Auth versus CircleCI"
  type        = bool
  default     = false
}
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
  default     = "4d73d934-e9c9-4e8d-af70-27eda8cb5e60"
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
variable "workspace_project_list" {
  description = "A list of string-maps containing workspace names correlated to project names in Terraform."
  type        = list(map(string))
  nullable    = false
  default     = []
}
variable "cci_iam_role_path" {
  description = "Path value to insert in the ARN of the CCI IAM role(s)."
  type        = string
  default     = "/oidc-auth/"
}
variable "tfe_iam_role_path" {
  description = "Path value to insert in the ARN of the Terraform IAM role(s)."
  type        = string
  default     = "/oidc-auth/"
}
locals {
  workspace_project_list = var.aws_config ? var.workspace_project_list : []
}
