output "azure_app_client_id" {
  description = "Client ID of the Azure App being created"
  value       = azuread_application.tfc_application.client_id
}

output "azure_app_object_id" {
  description = "The application's Object ID"
  value       = azuread_application.tfc_application.object_id
}

output "azure_credential_id_plan" {
  description = "UUID used to identify the PLANNING federated identity credential."
  value       = azuread_application_federated_identity_credential.tfc_federated_credential_plan.credential_id
}

output "azure_credential_id_apply" {
  description = "UUID used to identify the APPLY federated identity credential."
  value       = azuread_application_federated_identity_credential.tfc_federated_credential_apply.credential_id
}
