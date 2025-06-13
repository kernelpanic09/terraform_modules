variable "agent_pool_id" {
  type        = string
  description = "ID of an agent pool to assign to the workspace. Requires execution_mode to be set to agent."
  default     = null
}

variable "allow_destroy_plan" {
  type        = bool
  default     = false
  description = "Whether destroy plans can be queued on the workspace."
}

variable "assessments_enabled" {
  type        = bool
  description = "Toggle for automated assesments/drift detection."
  default     = true
}

variable "auto_apply" {
  type        = bool
  description = "True or False value to auto apply successful planning runs."
  default     = true
}

variable "auto_apply_run_trigger" {
  type        = bool
  description = "Whether to automatically apply changes for runs created by run triggers from other workspaces."
  default     = false
}

variable "aws_config" {
  type = object({
    run_role       = optional(string, "")
    alt_run_role   = optional(string, "")
    bootstrap      = bool
    account_number = optional(string, "")
    configure      = bool
  })
  default = {
    bootstrap      = true
    configure      = false
  }
  description = "The requisite values needed to configure a workspace for AWS communication and authentication."
  validation {
    condition     = ((length(regexall("arn:aws:iam::\\d{12}:role/\\S+", var.aws_config.run_role)) == 1) && (length(regexall("arn:aws:iam::\\d{12}:role/\\S+", var.aws_config.alt_run_role)) == 0)) || (length(regexall("arn:aws:iam::\\d{12}:role/\\S+", var.aws_config.alt_run_role)) == 1) || (var.aws_config.run_role == "")
    error_message = "Account number must be a 12 digit string.\nExactly one  'arn:aws:iam::<acct_num>:role/<role_name-with-path', or left blank."
  }
}

variable "azure_config" {
  type = object({
    client_app_id   = optional(string, "")
    subscription_id = optional(string, "")
    tenant_id       = optional(string, "")
    bootstrap       = bool
    configure       = bool
  })
  default = {
    bootstrap       = true
    configure       = false
  }
  description = "Requsite values needed to configure a workspace for Azure communication and authenticaiton."
  validation {
    condition     = ((length(regexall("^[\\da-zA-Z-]+", var.azure_config.client_app_id)) == 1) || (var.azure_config.client_app_id == "")) && ((length(regexall("^[\\da-zA-Z-]+", var.azure_config.subscription_id)) == 1) || (var.azure_config.subscription_id == "")) && ((length(regexall("^[\\da-zA-Z-]+", var.azure_config.tenant_id)) == 1) || (var.azure_config.tenant_id == ""))
    error_message = "Azure Client ID, Tenant ID, and Subscription IDs must be a multi-character alphanumeric string which may contain dashes."
  }
}

variable "execution_mode" {
  type        = string
  description = "Execution mode to use. Almost always should be set to remote."
  default     = "remote"
}

variable "file_triggers_enabled" {
  type        = bool
  default     = true
  description = <<EOF
(Optional) Whether to filter runs based on the changed files in a VCS push. Defaults to true.
If enabled, the working directory and trigger prefixes describe a set of paths which must contain changes for a VCS push to trigger a run.
If disabled, any push will trigger a run.
  EOF
}

variable "force_delete" {
  type        = bool
  default     = false
  description = <<EOF
(Optional) If this attribute is present on a workspace that is being deleted through the provider, it will use the existing force delete API.
If this attribute is not present or false it will safe delete the workspace.
EOF
}

variable "gcp_config" {
  type = object({
    configure              = bool
    bootstrap              = bool
    run_service_email      = optional(string, "")
    workload_provider_name = optional(string, "")
  })
  default = {
    bootstrap              = true
    configure              = false
  }
  description = "Requisite values needed to configure a workspace for GCP communication and authentication."
  validation {
    condition     = ((length(regexall("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$", var.gcp_config.run_service_email)) == 1) || var.gcp_config.run_service_email == "") && ((length(regexall("^projects/\\d+/locations/global/workloadIdentityPools/\\S+/\\S+$", var.gcp_config.workload_provider_name)) == 1) || var.gcp_config.workload_provider_name == "")
    error_message = <<EOF
Project number, service account email, workload pool and provider IDs are mandatory inputs for configuration of GCP with this workspace.
These values are easily obtained as the OUTPUTS from the GCP OIDC Terraform Module.
EOF
  }
}

variable "global_remote_state" {
  type        = bool
  default     = false
  description = <<EOF
Whether the workspace allows all workspaces in the organization to access its state data during runs.
If false, then only specifically approved workspaces can access its state (remote_state_consumer_ids).
EOF
}

variable "ignore_additional_tag_names" {
  type        = bool
  default     = true
  description = <<EOF
(Optional) Explicitly ignores tag_names not defined by config so they will not be overwritten by the configured tags.
This creates exceptional behavior in terraform with respect to tag_names and is not recommended.
This value must be applied before it will be used.
EOF
}

variable "oauth_token_id" {
  type        = string
  description = "OAuth Token ID to communicate with GitHub. This must be derived and passed in from the root module at runtime."
}

variable "queue_all_runs" {
  type        = bool
  default     = true
  description = <<EOF
Whether the workspace should start automatically performing runs immediately after its creation. Defaults to true.
When set to false, runs triggered by a webhook (such as a commit in VCS) will not be queued until at least one run has been manually queued.
EOF
}

variable "remote_state_consumer_ids" {
  type        = set(string)
  default     = null
  description = "The set of workspace IDs set as explicit remote state consumers for the given workspace."
}

variable "repo_branch" {
  type        = string
  description = "VCS branch name to be tracked for changes."
  default     = ""
}

variable "repo_name" {
  type        = string
  description = "Name of VCS repository the workspace is connected to."
}

variable "speculative_enabled" {
  type = bool
  default = true
  description = <<EOF
(Optional) Whether this workspace allows speculative plans. Defaults to true.
Setting this to false prevents HCP Terraform or the Terraform Enterprise instance from running plans on pull requests,
which can improve security if the VCS repository is public or includes untrusted contributors.
EOF
}

variable "structured_run_output_enabled" {
  type        = bool
  default     = true
  description = <<EOF
(Optional) Whether this workspace should show output from Terraform runs using the enhanced UI when available.
Defaults to true. Setting this to false ensures that all runs in this workspace will display their output as text logs.
EOF
}

variable "tfc_project" {
  type        = string
  description = "The TFC projet the workspace should be added to."
  default     = "Default Project"
}

variable "terraform_version" {
  type        = string
  description = "String value of terraform version to be used for this workspace. Constraints accepted"
  default     = null
}

variable "trigger_patterns" {
  type        = list(string)
  default     = null
  description = <<EOF
(Optional) List of glob patterns that describe the files HCP Terraform monitors for changes.
Trigger patterns are always appended to the root directory of the repository. Mutually exclusive with trigger-prefixes.
EOF
}

variable "trigger_prefixes" {
  type        = list(string)
  default     = null
  description = "List of repository-root-relative paths which describe all locations to be tracked for changes."
}

variable "working_directory" {
  type        = string
  description = "The working directory within the VCS repo to be used as root for the workspace."
  default     = "terraform"
}

variable "workspace_description" {
  type        = string
  description = "Optional friendly description to associate with this workspace."
  default     = ""
}

variable "workspace_name" {
  type        = string
  description = "Name of the TFC workspace being created."
}

locals {
  mandatory_tags = [
    "managed",
  ]
  workspace_tags = concat(var.workspace_tags,local.mandatory_tags)
}

variable "workspace_tags" {
  type = list(string)
  description = "List of string values to be applied to the workspace as metadata tags."
  default = []
}
