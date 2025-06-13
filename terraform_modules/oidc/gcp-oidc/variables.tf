variable "gcp_project_id" {
  type        = string
  description = "The ID of your GCP Project"

  validation {
    condition     = (length(var.gcp_project_id) > 0)
    error_message = "GCP OIDC must be set to TRUE and a GDP project ID must be provided!"
  }
}
variable "gcp_service_list" {
  description = "APIs required for the project"
  type        = list(string)
  default = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}
variable "tfc_hostname" {
  description = "The hostname of the TFC or TFE instance you are integrating with GCP"
  type        = string
  default     = "app.terraform.io"
}
variable "tfc_org_name" {
  type        = string
  description = "The organizational name of Org within Terrafom Cloud"
  default     = "orgname"
}
variable "tfc_project_name" {
  type        = string
  description = "The TFC Project to which this Identity will be associated."
  default     = "Default Project"
}
variable "tfc_workspace_name" {
  type        = string
  default     = "my-gcp-workspace"
  description = "The name of the TFC workspace that you're connecting to GCP."
}
