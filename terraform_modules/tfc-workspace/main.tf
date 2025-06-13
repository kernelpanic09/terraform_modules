terraform {
  required_providers {
    tfe = {
      version = "~> 0.61"
    }
  }
}

# Establish Constants
locals {
  tfc_org          = "orgname"
  tfc_hostname     = "app.terraform.io"
  tfc_project      = "default_project"
  master_workspace = "infrastructure-it-terraform-tfc"
  oauth_client     = "oc-e3MJn5gJacWKwgFQ"
  calc_run_role    = "arn:aws:iam::${var.aws_config.account_number}:role/oidc-auth/terraform-oidc-${var.workspace_name}"
}

# Obtain the Project ID based on the Project Name
data "tfe_project" "tfc_project" {
  organization = local.tfc_org
  name         = var.tfc_project
}

# Create the Workspace
resource "tfe_workspace" "managed_tfc_workspace" {
  allow_destroy_plan            = var.allow_destroy_plan
  assessments_enabled           = var.assessments_enabled
  auto_apply                    = var.auto_apply
  auto_apply_run_trigger        = var.auto_apply_run_trigger
  description                   = var.workspace_description
  file_triggers_enabled         = var.file_triggers_enabled
  force_delete                  = var.force_delete
  ignore_additional_tag_names   = var.ignore_additional_tag_names
  name                          = var.workspace_name
  organization                  = local.tfc_org
  project_id                    = data.tfe_project.tfc_project.id
  queue_all_runs                = var.queue_all_runs
  structured_run_output_enabled = var.structured_run_output_enabled
  speculative_enabled           = var.speculative_enabled
  tag_names                     = local.workspace_tags
  terraform_version             = var.terraform_version
  trigger_patterns              = var.trigger_patterns
  trigger_prefixes              = var.trigger_prefixes
  working_directory             = var.working_directory

  vcs_repo {
    identifier     = "${local.tfc_org}/${var.repo_name}"
    branch         = var.repo_branch
    oauth_token_id = var.oauth_token_id
  }
}

resource "tfe_workspace_settings" "managed_tfc_workspace_settings" {
  agent_pool_id             = var.agent_pool_id
  execution_mode            = var.execution_mode
  global_remote_state       = var.global_remote_state
  remote_state_consumer_ids = var.remote_state_consumer_ids
  workspace_id              = tfe_workspace.managed_tfc_workspace.id
}

#
# AWS WORKSPACE VARIABLES
#
# Create a TFC_AWS_PROVIDER_AUTH variable equal to True for an AWS facing workspace
resource "tfe_variable" "tfc_aws_provider_auth_var" {
  count        = (var.aws_config.configure == true) ? 1 : 0
  key          = "TFC_AWS_PROVIDER_AUTH"
  value        = !(var.aws_config.bootstrap)
  category     = "env"
  description  = "Toggles OIDC auth between TFC and AWS for account: ${var.aws_config.account_number}"
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

# Create a TFC_AWS_RUN_ROLE_ARN variable, assuming default value is not overriden
resource "tfe_variable" "tfc_aws_run_role_arn_var" {
  count        = (var.aws_config.configure == true) ? 1 : 0
  key          = "TFC_AWS_RUN_ROLE_ARN"
  value        = (var.aws_config.alt_run_role == "") ? local.calc_run_role : var.aws_config.alt_run_role
  category     = "env"
  description  = "AWS ARN value of OIDC role to be assumed by this workspace."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

#
# Azure WORKSPACE VARIABLES
#
# Create a TFC_AZURE_PROVIDER_AUTH variable equal to True for an Azure facing workspace
resource "tfe_variable" "tfc_azure_provider_auth_var" {
  count        = (var.azure_config.configure == true) ? 1 : 0
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = !(var.azure_config.bootstrap)
  category     = "env"
  description  = "Toggles OIDC auth between TFC and Azure for client: ${var.azure_config.client_app_id}"
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

# Create a TFC_AZURE_RUN_CLIENT_ID variable
resource "tfe_variable" "tfc_azure_run_client_id_var" {
  count        = ((var.azure_config.configure == true) && (var.azure_config.client_app_id != "")) ? 1 : 0
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = var.azure_config.client_app_id
  category     = "env"
  description  = "Azure Client ID for OIDC role to be assumed by this workspace."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

resource "tfe_variable" "tfc_azure_arm_tenant_var" {
  count        = ((var.azure_config.configure == true) && (var.azure_config.tenant_id != "")) ? 1 : 0
  key          = "ARM_TENANT_ID"
  value        = var.azure_config.tenant_id
  category     = "env"
  description  = "Azure Tenant ID for this Subscription."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

resource "tfe_variable" "tfc_azure_arm_subscription_id_var" {
  count        = ((var.azure_config.configure == true) && (var.azure_config.subscription_id != "")) ? 1 : 0
  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.azure_config.subscription_id
  category     = "env"
  description  = "Azure Subscription which OIDC will be used to authenticate against."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

#
# GCP WORKSPACE VARIABLES
#
# Create a TFC_GCP_PROVIDER_AUTH variable
resource "tfe_variable" "tfc_gcp_provider_auth_var" {
  count        = (var.gcp_config.configure == true) ? 1 : 0
  key          = "TFC_GCP_PROVIDER_AUTH"
  value        = !(var.gcp_config.bootstrap)
  category     = "env"
  description  = "Boolean toggle to enable/disable OIDC authentication."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

# Create TFC_GCP_SERVICE_ACCOUNT_EMAIL variable
resource "tfe_variable" "tfc_gcp_run_service_account_email_var" {
  count        = ((var.gcp_config.configure == true) && (var.gcp_config.run_service_email != "")) ? 1 : 0
  key          = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value        = var.gcp_config.run_service_email
  category     = "env"
  description  = "The service account email TFC will use when authenticating to GCP."
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}

# Create the TFC_GCP_WORKLOAD_PROVIDER_NAME variable
resource "tfe_variable" "tfc_gcp_workload_provider_name_var" {
  count        = ((var.gcp_config.configure == true) && (var.gcp_config.workload_provider_name != "")) ? 1 : 0
  key          = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value        = var.gcp_config.workload_provider_name
  category     = "env"
  description  = "Canonical name of the GCP Workload Provider"
  workspace_id = tfe_workspace.managed_tfc_workspace.id
}
