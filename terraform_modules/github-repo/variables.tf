variable "allow_auto_merge" {
  default     = false
  description = "Enable the ability to automatically merge on this repository."
  type        = bool
}

variable "allow_bypass_update" {
  default     = false
  description = "Only allow users with bypass permissions to update matching refs."
  type        = bool
}

variable "allow_merge_commit" {
  default     = false
  description = "Enable merge commits on the repository."
  type        = bool
}

variable "allow_rebase_merge" {
  default     = false
  description = "Enable rebase merges on the repository."
  type        = bool
}

variable "allow_squash_merge" {
  default     = true
  description = "Enable squash merges on the repository."
  type        = bool
}

variable "allow_update_branch" {
  default     = true
  description = "Enables suggestions to update pull request branches."
  type        = bool
}

variable "archived" {
  default     = false
  description = "Whether or not the repository has been archived. Presently no way to un-archive via API."
  type        = bool
}

variable "auto_init" {
  default     = true
  description = "Enables a first commit to be auto applied to newly created repositories."
  type        = bool
}

variable "bootstrap" {
  default     = false
  description = "Used to temporarily disable infosec-required branch rules. Meant for setting up a new repository, not not be enabled long-term!"
  type        = bool
}

variable "default_branch" {
  default     = "main"
  description = "The name of the default/primary branch of the repository."
  type        = string
}

variable "delete_branch_on_merge" {
  default     = true
  description = "Enables the automatic deletion of source branch on successful merge."
  type        = bool
}

variable "description" {
  default     = ""
  description = "A descriptive phrase identifying the repository."
  type        = string
}

variable "dismiss_stale" {
  default     = true
  description = "Whether or not to dismiss stale approvals."
  type        = bool
}

variable "gitignore_template" {
  default     = null
  description = "Named template file from: https://github.com/github/gitignore"
  type        = string
}

variable "has_downloads" {
  default     = true
  description = "Enables the downloading of resources from this repository."
  type        = bool
}

variable "has_issues" {
  default     = true
  description = "Enables the issues feature on this repository."
  type        = bool
}

variable "has_projects" {
  default     = true
  description = "Enables the projects feature on this repository."
  type        = bool
}

variable "has_wiki" {
  default     = false
  description = "Enables the Wiki feature for this repository."
  type        = bool
}

variable "homepage_url" {
  default     = null
  description = "(optional) URL of a page describing the project."
  type        = string
}

variable "merge_commit_message" {
  default     = "PR_TITLE"
  description = "One of: PR_BODY, PR_TITLE, or BLANK. Applicable only if alllow_merge_commit is true."
  type        = string
}

variable "merge_commit_title" {
  default     = "MERGE_MESSAGE"
  description = "One of: PR_TITLE, MERGE_MESSAGE. Applicable only if allow_merge_commit is true."
  type        = string
}

variable "no_bypass" {
  default     = true
  description = "Prevents users with push access from force pushing to branches."
  type        = bool
}

variable "pages_build_type" {
  default     = null
  description = "The type of GitHub Pages to build. Can be 'legacy' or 'workflow'. If you use 'legacy' as build type, you must set the option 'source' as well."
  validation {
    condition     = ((var.pages_build_type == "legacy") || (var.pages_build_type == "workflow") || (var.pages_build_type == null))
    error_message = "Can only be 'legacy' or 'workflow'. If 'legacy' you must also specify the 'source' option."
  }
}

variable "pages_cname" {
  default     = null
  description = "(optional) The custom domain for the repository. This can only be set after the repository has been created."
  type        = string
}

variable "pages_source_branch" {
  default     = null
  description = "The repository branch used to publish the site's source files."
  type        = string
}

variable "pages_source_path" {
  default     = null
  description = "(optional) The repository directory from which the site publishes."
  type        = string
}

variable "permissions_engineering" {
  default     = false
  description = "Boolean denoting the appliction of default allotment of Engineering based permissions to this repository."
  type        = bool
}

variable "permissions_ignore" {
  default = [
    "product-security",
  ]
  description = "List of GitHub teams to be IGNORED with regard to permissions assignments."
  type        = list(string)
}

variable "permissions_trust" {
  default     = false
  description = "Boolean denoting the application of default allotment of Trust based permissions to this repository."
  type        = bool
}

variable "property_audit_scope" {
  default     = true
  description = "Boolean denoting whether this repository is within scope for the annual audit."
  type        = bool
}

variable "property_product_code" {
  default     = false
  description = "Boolean denoting whether this repository contains platform product code."
  type        = bool
}

variable "repository_admins_teams" {
  default     = []
  description = "List of GitHub team IDs to be assigned as ADMINs to this repository."
  type        = list(string)
}

variable "repository_admins_users" {
  default     = []
  description = "List of GitHub user IDs to be assigned as ADMINs to this repository."
  type        = list(string)
}

variable "repository_collaborators" {
  default     = []
  description = "(Optional) List of teams/users identified as collaborators to the repository."
  type = list(object({
    permission = optional(string, "pull")
    team_id    = optional(string, "")
  }))
}

variable "repository_maintainers_teams" {
  default     = []
  description = "List of GitHub teams to be assigned MAINTAIN access to this repository."
  type        = list(string)
}

variable "repository_maintainers_users" {
  default     = []
  description = "List of GitHub users to be assigned MAINTAIN access to this repository."
  type        = list(string)
}

variable "repository_name" {
  description = "Name to be used for this repository."
  type        = string
}

variable "repository_readers_teams" {
  default     = []
  description = "List of GitHub teams to be assigned READ access to this repository."
  type        = list(string)
}

variable "repository_readers_users" {
  default     = []
  description = "List of GitHub users to be assigned READ access to this repository."
  type        = list(string)
}

variable "repository_triage_teams" {
  default     = []
  description = "List of GitHub teams to be assigned TRIAGE access to this repository."
  type        = list(string)
}

variable "repository_triage_users" {
  default     = []
  description = "List of GitHub users to be assigned TRIAGE access to this repository."
  type        = list(string)
}

variable "repository_visibility" {
  default     = "private"
  description = "Either: public or private. Visibility parameter overrides the private parameter."
  type        = string
}

variable "repository_writers_teams" {
  default     = []
  description = "List of GitHub teams to be assigned WRITE access to this repository."
  type        = list(string)
}

variable "repository_writers_users" {
  default     = []
  description = "List of GitHub users to be assigned WRITE access to this repository."
  type        = list(string)
}

variable "require_codeowner_review" {
  default     = true
  description = "Whether or not to require a codeowner to review pull requests to this repository."
  type        = bool
}

variable "require_last_push_approval" {
  default     = true
  description = "Wether or not to require approval for the most recent reviewable push."
  type        = bool
}

variable "require_code_signing" {
  default     = false
  description = "Require commits are digitally signed by the author."
  type        = bool
}

variable "require_conversation_resolution" {
  default     = false
  description = "All conversations on code must be resolved before a pull requrest can be merged."
  type        = bool
}

variable "require_passing_status_checks" {
  default     = true
  description = "Whether to require chosen status checks to pass before merge is permitted."
  type        = bool
}

variable "require_linear_history" {
  default     = true
  description = "Prevent merge commits from being pushed to matching branches."
  type        = bool
}

variable "squash_merge_commit_message" {
  default     = "COMMIT_MESSAGES"
  description = "One of: PR_BODY, COMMIT_MESSAGES, or BLANK. Applicable only if allow_squash_merge is true."
  type        = string
  validation {
    condition     = (var.squash_merge_commit_message == "PR_BODY") || (var.squash_merge_commit_message == "COMMIT_MESSAGES") || (var.squash_merge_commit_message == "BLANK")
    error_message = "Must be one of: PR_BODY, COMMIT_MESSAGES, or BLANK"
  }
}

variable "squash_merge_commit_title" {
  default     = "COMMIT_OR_PR_TITLE"
  description = "One of: PR_TITLE, COMMIT_OR_PR_TITLE. Applicable only if allow_squash_merge is true."
  type        = string
  validation {
    condition     = (var.squash_merge_commit_title == "PR_TITLE") || (var.squash_merge_commit_title == "COMMIT_OR_PR_TITLE")
    error_message = "Must be one of: PR_TITLE or COMMIT_OR_PR_TITLE"
  }
}

variable "template_owner" {
  default     = null
  description = "The GitHub organization or user the template repository is owned by."
  type        = string
}

variable "template_repository" {
  default     = null
  description = "The name of the template repository."
  type        = string
}

variable "template_include_all_branches" {
  default     = null
  description = "Whether the new repository should include all branches from template repository. False includes only default branch."
  type        = bool
}

variable "template_pull_request" {
  default     = false
  description = "Deploys the standard Pull Request template file."
  type        = bool
}

variable "template_pull_request_file" {
  default     = "./repo_content/pull_request_template.md"
  description = "Absolute path and file name of the Pull Request Template file."
  type        = string
}

variable "vulnerability_alerts" {
  default     = true
  description = "Enables security alerts for vulnerable dependencies. Alerts must also be enabled on the Org level."
  type        = bool
}

variable "web_commit_sign_off_required" {
  default     = false
  description = "(optional) Require contributors to sign off on web-based commits."
  type        = bool
}

variable "workflow_wiz-iac" {
  default     = false
  description = "Deploys the Wiz-IaC GitHub action to this repository."
  type        = bool
}

variable "workflow_wiz-iac_file" {
  default     = "./repo_content/wiz-iac.yml"
  description = "Absolute path and file name of the Wiz-IaC action's YAML file."
  type        = string
}
