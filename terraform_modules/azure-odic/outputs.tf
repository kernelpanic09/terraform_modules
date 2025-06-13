output "azure_subscription_id" {
  description = <<EOF
  The ID of the Azure Subscription.
  To be used for Terraform Workspace environment variable: **ARM_SUBSCRIPTION_ID**
EOF
  value       = data.azurerm_subscription.current.subscription_id
}
output "azure_tenant_id" {
  description = <<EOF
  The Azure Tenant ID for this subscription.
  To be used for the Terraform Workspace environment variable: **ARM_TENANT_ID**
EOF
  value       = data.azurerm_subscription.current.tenant_id
}

locals {
  sp_display_names = [for sp in azuread_service_principal.tfc_service_principal : sp.display_name]
  sp_object_ids    = [for sp in azuread_service_principal.tfc_service_principal : sp.id]
  client_ids       = [for client in azuread_application.tfc_application : client.client_id]
  client_ids_map = [for k, v in zipmap(local.sp_display_names, local.client_ids) : {
    service_principal_name = k
    client_id              = v
  }]
  sp_ids_map = [for k, v in zipmap(local.sp_display_names, local.sp_object_ids) : {
    service_principal_name = k
    service_principal_id   = v
  }]
}

output "azure_client_ids_map" {
  description = "Map of Azure Client IDs to Service Principals"
  value       = local.client_ids_map
}
output "azure_service_principal_ids_map" {
  description = "Map of the Azure Service Principal IDs to Display Names"
  value       = local.sp_ids_map
}
