variable "azure_app_reg_name" {
  description = "Display name for the Azure application registration. Usually wants to match the TFC Workspace Name"
  type        = string

  validation {
    condition     = (length(var.azure_app_reg_name) > 0)
    error_message = "Azure App Registration name must be provided!"
  }
}

variable "tfc_azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in Azure run identity tokens"
}

variable "tfc_org_name" {
  type        = string
  description = "The organizational name of Org Name within Terrafom Cloud"
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
