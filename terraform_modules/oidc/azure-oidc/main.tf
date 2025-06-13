# First, obtain the current subscription ID
data "azurerm_subscription" "current" {
}

# Create the App Regisitration in Azure AD
resource "azuread_application" "tfc_application" {
  display_name = var.azure_app_reg_name
}

# Create Service Principal for App Registration
resource "azuread_service_principal" "tfc_service_principal" {
  client_id = azuread_application.tfc_application.client_id
}

# Create a role assignment determining the permissions of the service principal within the subscription
resource "azurerm_role_assignment" "tfc_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azuread_service_principal.tfc_service_principal.object_id
  role_definition_name = "Contributor"
}

# Create a federated ID whcih esures the given workspace will be able to auth to Azure for the Plan phase
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_plan" {
  application_id = azuread_application.tfc_application[count.index].object_id
  display_name   = "${var.azure_app_reg_name}-plan"
  audiences      = [var.tfc_azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_org_name}:project:${var.tfc_project_name}:workspace:${var.azure_app_reg_name}:run_phase:plan"
}

# Create a federated ID whcih esures the given workspace will be able to auth to Azure for the Apply phase
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_apply" {
  application_id = azuread_application.tfc_application[count.index].object_id
  display_name   = "${var.azure_app_reg_name}-apply"
  audiences      = [var.tfc_azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_org_name}:project:${var.tfc_project_name}:workspace:${var.azure_app_reg_name}:run_phase:apply"
}
