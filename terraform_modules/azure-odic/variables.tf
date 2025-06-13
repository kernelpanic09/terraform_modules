variable "tfc_azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in Azure run identity tokens"
}
variable "tfc_org_name" {
  type        = string
  description = "The organizational name of Org within Terrafom Cloud"
  default     = "orgname"
}
variable "tfc_hostname" {
  description = "The hostname of the TFC or TFE instance you are integrating with AWS"
  type        = string
  default     = "app.terraform.io"
}
variable "workspace_project_list" {
  type        = list(map(string))
  nullable    = false
  description = "A list of string-maps containing workspace names correlated to project names."
}
variable "role_assignment_scope" {
  type        = string
  default     = ""
  description = <<EOT
Azure scope at which to apply role assignment.
The ID of one of either a managmenet group, subscription, or resource group.
Defaults to the current subscription ID if nothing is speciifed.
EOT
}
variable "role_definition_name" {
  type        = string
  default     = "Owner"
  description = "The Role name to ascribe to the App Registration. Contributor, Owner, etc."
}
