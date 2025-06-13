output "workspace_id" {
  value       = tfe_workspace.managed_tfc_workspace.id
  description = "Terraform Cloud internal ID of the workspace."
}

output "aws_run_role" {
  value       = ((var.aws_config.configure == true) && (var.aws_config.bootstrap == false)) ? tfe_variable.tfc_aws_run_role_arn_var[0].readable_value : null
  description = "AWS run role ARN to be used by this workspace."
}

output "azure_client_id" {
  value       = ((var.azure_config.configure == true) && (var.azure_config.bootstrap == false)) ? tfe_variable.tfc_azure_run_client_id_var[0].readable_value : null
  description = "Azure Client ID for the App Registration Associated with this workspace."
}

output "gcp_run_service_email" {
  value       = ((var.gcp_config.configure == true) && (var.gcp_config.bootstrap == false)) ? tfe_variable.tfc_gcp_run_service_account_email_var[0].readable_value : null
  description = "GCP service account email used to authenticate this workspace with GCP."
}

output "gcp_workload_provider_name" {
  value       = ((var.gcp_config.configure == true) && (var.gcp_config.bootstrap == false)) ? tfe_variable.tfc_gcp_workload_provider_name_var[0].readable_value : null
  description = "Cannonical name of the Google Cloud Platform ID Pool Provider servicing this workspace."
}
