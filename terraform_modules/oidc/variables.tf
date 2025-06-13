
variable "tfc_oidc" {
  description = "Boolean instructing module to create terraform OIDC provider resources"
  type        = bool
  default     = false
}

variable "cci_oidc" {
  description = "Boolean instructing module to create CircleCi OIDC provider resources"
  default     = false
  type        = bool
}

variable "azure_oidc" {
  description = "Boolean instructing module to create Azure OIDC provider resources"
  default     = false
  type        = bool
}

variable "gcp_oidc" {
  description = "Boolean instructing module to create Google Cloud OIDC provider resources"
  default     = false
  type        = bool
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

variable "tfc_hostname" {
  description = "The hostname of the TFC or TFE instance you are integrating with AWS"
  type        = string
  default     = "app.terraform.io"
}

variable "azure_app_reg_name" {
  description = "Human readable name for this Azure Application Registration"
  type        = string
  default     = ""
}

variable "gcp_project_id" {
  description = "The GCP project ID to be used for this OIDC implementation."
  type        = string
  default     = ""
}
