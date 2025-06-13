☁️ GCP OIDC Terraform Module

This module provisions all necessary resources to enable OIDC authentication from Terraform Cloud Workspaces to Google Cloud Platform (GCP). It eliminates the need for storing static credentials, leveraging Workload Identity Federation for secure, short-lived access.

📖 Terraform Cloud Dynamic GCP Credentials Documentation
📦 Dependencies

    Google Terraform Provider ~> 5.35

    Terraform CLI >= 0.12.0

⚙️ Prerequisites

This module provisions the required GCP resources (Workload Identity Pool, Providers, Service Accounts, IAM roles), but you must configure the Terraform Cloud Workspace to finalize OIDC authentication.
🔐 Required Workspace Environment Variables

    Note: These are not sensitive.

Variable	Description
TFC_GCP_PROVIDER_AUTH	Set to "true" to enable OIDC authentication
TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL	Email of the service account created for the workspace
TFC_GCP_WORKLOAD_PROVIDER_NAME	Canonical provider name in GCP format:
projects/{project_number}/locations/global/workloadIdentityPools/{pool_id}/providers/{provider_id}

You can set these manually in the Terraform Cloud UI, or programmatically using the TFE Provider.
🔧 What This Module Does

For each workspace in the workspace_project_list, the module:

    Creates a Workload Identity Pool and one Provider per workspace

    Configures OIDC claim mappings and subject conditions tied to the specific workspace

    Provisions a unique GCP Service Account per workspace

    Grants necessary IAM roles to each service account

    Binds the service account to the Workload Identity Pool for OIDC trust

    Enables required GCP APIs

🧩 Usage

module "gcp_oidc" {
  source  = "app.terraform.io/orgname/rc-gcpoidc/gcp"
  version = "0.X.Y"

  workspace_project_list = [
    {
      workspace_name = "my_terraform_workspace"
      project_name   = "Default Project"
    },
    {
      workspace_name = "my_other_workspace"
      project_name   = "Engineering Project"
    }
  ]
}

    The workspace_project_list is a list of maps, each with workspace_name and project_name. Add one entry per workspace you wish to enable for GCP OIDC authentication.

🔐 Identity & Permissions Overview

    Workload Identity Pool & Provider
    Configures identity federation from Terraform Cloud OIDC tokens

    Service Account
    Each workspace gets a dedicated service account

    IAM Roles Granted

        roles/editor

        roles/iam.serviceAccountAdmin

        roles/iam.workloadIdentityUser

        roles/iam.workloadIdentityPoolAdmin

    IAM permissions can be customized as needed.

✅ Final Steps

    Apply this module to create the GCP resources.

    Set workspace variables (TFC_GCP_*) in Terraform Cloud.

    Run a plan/apply from the workspace to verify dynamic credentials are working.

