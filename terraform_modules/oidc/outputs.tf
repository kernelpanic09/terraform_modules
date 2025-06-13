output "tfc-service-role" {
  value       = var.tfc_oidc ? module.aws_oidc.aws_run_role_arn : null
  description = "The IAM role user-context under which Terraform drives AWS"
}

output "tfc-oidc-provider" {
  description = "The IAM OIDC Identitiy Provider for Terraform Cloud"
  value       = var.tfc_oidc ? module.tfc_oidc.aws_tfc_idp_arn : null
}

output "cci-service-role" {
  value       = var.cci_oidc ? module.cci_oidc.cci_run_role_arn.arn : null
  description = "The IAM role user-context under which CircleCi drives AWS"
}

output "cci-oidc-provider" {
  description = "The IAM OIDC Identity Provider for CircleCi"
  value       = var.cci_oidc ? module.cci_oidc.aws_tfc_idp_arn : null
}

output "azure-client-id" {
  description = "The Client ID for the Azure App Registration"
  value       = var.azure_oidc ? module.azure_oidc.azure_app_client_id : null
}

output "azure-planning-credential" {
  description = "The Azure credential assigned to the planning phase"
  value       = var.azure_oidc ? module.azure_oidc.azure_credential_id_plan : null
}

output "azure-apply-credential" {
  description = "The Azure credential assigned to the apply phase"
  value       = var.azure_oidc ? module.azure_oidc.azure_credential_id_apply : null
}

output "azure-app-object-id" {
  description = "The application's Object ID"
  value       = module.azure_oidc.azure_app_object_id
}

output "gcp_identity_pool_id" {
  description = "An identifier for the ID pool in the format:\nprojects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}"
  value       = module.gcp_oidc.gcp_identity_pool_id
}

output "gcp_identity_pool_provider_id" {
  description = "An identifier for the ID pool provider in the format:\nprojects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}/providers/{{workload_identity_pool_provider_id}}"
  value       = module.gcp_oidc.gcp_identity_pool_provider_id
}

output "gcp_service_account_id" {
  description = "An identifer for the service account in the format:\nprojects/{{project}}/serviceAccounts/{{email}}"
  value       = module.gcp_oidc.gcp_service_account_id
}

output "gcp_service_account_email" {
  description = "The email addresss of the service account."
  value       = module.gcp_oidc.gcp_service_account_email
}

output "gcp_service_account_name" {
  description = "The fully qualified name of the service account"
  value       = module.gcp_oidc.gcp_service_account_name
}
