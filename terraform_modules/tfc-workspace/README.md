🏗️ Terraform Cloud Workspaces Module

This module automates the creation and configuration of Terraform Cloud (TFC) workspaces. It supports multi-cloud OIDC authentication (AWS, Azure, GCP) and offers optional bootstrapping logic to help transition workspaces from static credentials to dynamic OIDC-based credentials.
🎯 Purpose

    Create TFC workspaces with secure and consistent settings

    Configure cloud-specific OIDC environment variables

    Enable Git-based VCS integration with default or custom configurations

    Support for bootstrap-first workflows using temporary credentials

⚙️ Features

    Creates a workspace in a specified TFC organization and project

    Configures VCS repository integration

    Automatically sets OIDC authentication variables for:

        AWS (TFC_AWS_*)

        Azure (TFC_AZURE_*, ARM_*)

        GCP (TFC_GCP_*)

    Supports bootstrapping logic via bootstrap = true to delay OIDC enablement until cloud roles/service accounts are ready

🔁 Bootstrapping Workflow

Some cloud providers require OIDC trust resources to exist before TFC can authenticate via OIDC. This module supports a two-phase approach:

    Bootstrap Phase (bootstrap = true)

        OIDC variables are configured but set to disable OIDC usage

        Temporary credentials are required to create the OIDC trust resources

    Transition Phase (bootstrap = false)

        Re-apply the module

        OIDC variables are enabled

        Workspace switches to dynamic credentials

📦 Dependencies
Tool	Version
Terraform	>= 0.12.0
TFE Provider	~> 0.61

Environment variable required:

    TFE_TOKEN – your Terraform Cloud API token

🧩 Example Usage

module "it-infrastructure-workspace" {
  source  = "app.terraform.io/org/tfeworkspace/tfe"
  version = "X.Y.Z"

  workspace_name        = "it-infrastructure-aws-workspaces"
  repo_name             = "it-infrastructure-aws-workspaces"
  workspace_description = "Deploys and manages AWS infrastructure via Terraform Cloud."

  aws_config = {
    configure      = true
    bootstrap      = false
    account_number = "123456789012"
    alt_run_role   = "arn:aws:iam::123456789012:role/tfc-role"
  }

  azure_config = {
    configure       = false
    bootstrap       = true
    client_app_id   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }

  gcp_config = {
    configure              = false
    bootstrap              = true
    run_service_email      = ""
    workload_provider_name = "projects/{project_id}/locations/global/workloadIdentityPools/{pool}/providers/{provider}"
  }
}

    📝 Each cloud config block is optional. Include only the providers you want to enable.

🧾 Environment Variables Set by This Module
AWS
Key	Example Value
TFC_AWS_PROVIDER_AUTH	true or false
TFC_AWS_RUN_ROLE_ARN	arn:aws:iam::123456789012:role/terraform-oidc-my-workspace
Azure
Key	Example Value
TFC_AZURE_PROVIDER_AUTH	true or false
TFC_AZURE_RUN_CLIENT_ID	Azure App Client ID
ARM_TENANT_ID	Azure Tenant ID
ARM_SUBSCRIPTION_ID	Azure Subscription ID
GCP
Key	Example Value
TFC_GCP_PROVIDER_AUTH	true or false
TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL	terraform@project.iam.gserviceaccount.com
TFC_GCP_WORKLOAD_PROVIDER_NAME	projects/1234567890/locations/global/workloadIdentityPools/my-pool/providers/my-provider
📚 Best Practices

    Use separate .tf files per workspace for clarity and traceability.

    Keep bootstrap flags clearly documented in pull requests.

    Only re-apply the module after cloud-side OIDC roles/policies are created.

