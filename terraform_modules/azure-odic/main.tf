# First, obtain the current subscription ID
data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}
data "azuread_application_published_app_ids" "well_known" {}

# Obtain All Service Principals
data "azuread_service_principals" "all" {
  return_all = true
}
# Create the App Regisitration in Azure AD
resource "azuread_application" "tfc_application" {
  for_each     = { for w in var.workspace_project_list : w.workspace_name => w }
  display_name = "terraform-oidc-${each.value.workspace_name}"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["AppRoleAssignment.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Device.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Directory.ReadWrite.All"]
      type = "Role"
    }
        resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Domain.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
        resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Policy.Read.All"]
      type = "Role"
    }
        resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["RoleManagement.ReadWrite.Directory"]
      type = "Role"
    }
  }
}
# Importing a pre-existing Service Principal, this is not making a new one!
resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}
# Create Service Principal for App Registration
resource "azuread_service_principal" "tfc_service_principal" {
  for_each  = azuread_application.tfc_application
  client_id = each.value.client_id
  owners = [data.azuread_client_config.current.object_id]
}
# Create a role assignment determining the permissions of the service principal within the subscription
locals {
  role_assignment_scope = (length(var.role_assignment_scope) > 0) ? var.role_assignment_scope : data.azurerm_subscription.current.id
}
resource "azurerm_role_assignment" "tfc_role_assignment" {
  for_each             = azuread_service_principal.tfc_service_principal
  scope                = local.role_assignment_scope
  principal_id         = each.value.object_id
  role_definition_name = var.role_definition_name
}
# Create a federated ID whcih esures the given workspace will be able to auth to Azure Planning Runs (wildcards not supported!)
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_plan" {
  for_each       = { for w in var.workspace_project_list : w.workspace_name => w}
  application_id = "/applications/${azuread_application.tfc_application[each.value.workspace_name].object_id}"
  display_name   = "${urlencode(each.value.workspace_name)}-plan"
  audiences      = [var.tfc_azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_org_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:plan"
  description    = "Terraform Cloud PLANNING service credential for workspace: ${each.value.workspace_name}, under Terraform project: ${each.value.project_name}"
}
# Create a federated ID whcih esures the given workspace will be able to auth to Azure Apply Runs (wildcards not supported!)
resource "azuread_application_federated_identity_credential" "tfc_federated_credential_apply" {
  for_each       = { for w in var.workspace_project_list : w.workspace_name => w }
  application_id = "/applications/${azuread_application.tfc_application[each.value.workspace_name].object_id}"
  display_name   = "${urlencode(each.value.workspace_name)}-apply"
  audiences      = [var.tfc_azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_org_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:apply"
  description    = "Terraform Cloud APPLY service credential for workspace: ${each.value.workspace_name}, under Terraform project: ${each.value.project_name}"
}
# Grant specific API access required to operate Terraform Workspaces
resource "azuread_app_role_assignment" "application_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "app_role_assign_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["AppRoleAssignment.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "device_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Device.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "directory_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Directory.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "domain_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Domain.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "group_rw_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "policy_read_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Policy.Read.All"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
resource "azuread_app_role_assignment" "rolemgmt_rw_dir_access" {
  for_each            = azuread_service_principal.tfc_service_principal
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["RoleManagement.ReadWrite.Directory"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
