🔐 Azure OIDC Terraform Module

This module provisions all the necessary Azure Active Directory (AAD) resources to enable OIDC (OpenID Connect) authentication between Terraform Cloud Workspaces and Azure. It allows Terraform to assume short-lived, secure identities without storing static Azure credentials.
📦 Dependencies

This module requires the following Terraform providers:

    AzureAD Provider ~> 3.109

    AzureRM Provider ~> 2.52

    Terraform CLI >= 0.12.0

⚙️ Prerequisites

This module provisions resources only—it does not automatically configure the Terraform Cloud workspace to use OIDC. To complete the setup, you must manually or programmatically define the following environment variables in each workspace:
Variable	Description
TFC_AZURE_RUN_CLIENT_ID	The Azure AD application (client) ID created by this module for your workspace
TFC_AZURE_PROVIDER_AUTH	Must be set to "true" to enable OIDC-based provider authentication

    ⚠️ These variables are not sensitive and can be safely defined via the UI, API, or Terraform Cloud (TFE) provider.

🚀 What This Module Does

For each workspace defined in workspace_project_list, this module:

    Creates an AAD Application Registration (azuread_application)

    Creates a corresponding Service Principal

    Assigns the Service Principal a custom or predefined Azure RBAC role (e.g., Contributor, Reader, etc.)

    Grants Microsoft Graph application permissions (e.g., Directory.ReadWrite.All)

    Creates two federated identity credentials (plan & apply phases)

    Supports customization of the role assignment scope

    OIDC subject claim format:

organization:<TFC_ORG>:project:<TFC_PROJECT>:workspace:<TFC_WORKSPACE>:run_phase:<plan|apply>

🧩 Usage

Paste this into a Terraform configuration file (e.g., azure_oidc.tf):

module "azure_oidc" {
  source  = "app.terraform.io/orgname/rc-azureoidc/azure"
  version = "0.X.Y"

  workspace_project_list = [
    {
      workspace_name = "infra-workspace"
      project_name   = "Default Project"
    },
    {
      workspace_name = "prod-deployments"
      project_name   = "Production"
    }
  ]

  # Optional overrides
  role_definition_name = "Contributor"
  role_assignment_scope = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

📘 Notes

    Wildcard subjects are not supported. Each federated credential is scoped to a specific workspace and run phase.

    The module supports multiple workspaces and handles role assignment per service principal.

    This is ideal for Terraform Cloud Dynamic Credentials on Azure.

🛠 Example Workspace Variables (Required)
Key	Value
TFC_AZURE_PROVIDER_AUTH	true
TFC_AZURE_RUN_CLIENT_ID	<< Output from this module >>