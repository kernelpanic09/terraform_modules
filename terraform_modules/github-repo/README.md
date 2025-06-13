📦 GitHub Repository Terraform Module

This module provisions and configures a GitHub repository with secure defaults, automated branch protections, baseline permissions (for Engineering and/or Trust teams), and optional workflow/template scaffolding. It’s designed to ensure every repository is ready for immediate use—secure, compliant, and properly governed.
<p align="center"> <img src="https://github.com/user-attachments/assets/63f84260-1501-4636-9789-0fb64081c4f2" width="400"/> </p>
✨ Features

    Creates a GitHub repository with customizable attributes

    Initializes the repo with a branch and first commit

    Applies baseline branch protection rules

    Assigns GitHub team/user permissions for:

        Admin

        Maintain

        Write (Push)

        Read (Pull)

        Triage

    Supports Trust and Engineering permission presets

    Automatically deploys:

        PR Templates

        GitHub Actions (e.g. Wiz IaC Scanner)

    Sets custom GitHub repository properties (e.g., managed, audit_scope)

🚀 Usage

module "repository" {
  source  = "app.terraform.io/orgname/github-repo"
  version = "x.y.z"

  repository_name  = "awesome-repo"
  repository_visibility = "private"
  default_branch   = "main"
  allow_auto_merge = true

  permissions_engineering = true
  permissions_trust       = false

  workflow_wiz-iac        = true
  workflow_wiz-iac_file   = "${path.module}/.github/workflows/wiz-iac.yml"

  template_pull_request       = true
  template_pull_request_file  = "${path.module}/.github/pull_request_template.md"

  property_audit_scope    = "true"
  property_product_code   = "true"
}

    Set permissions_engineering or permissions_trust to true to automatically apply team permissions (see below).

🛡️ Repository Security
🔧 Trust Repositories

Enable with:

permissions_trust = true

Role	Teams Assigned
Admin	it-leadership
Writer	corporate-security
Maintainer	it-support, systems-engineering
🧪 Engineering Repositories

Enable with:

permissions_engineering = true

Role	Teams Assigned
Admin	cso-leadership, incident-commanders, principal-engineers
Writer	customer-security-operations, engineering
Reader	product-security
Maintainer	staff-engineers

    ✅ If both permissions_trust and permissions_engineering are enabled, the module will merge teams and assign the highest effective permission per team.

🔍 Custom Permissions (Ad-Hoc)

Define your own GitHub team access:

    repository_admins_teams

    repository_maintainers_teams

    repository_writers_teams

    repository_readers_teams

    repository_triage_teams

Also supported:

    *_users: Assign by individual GitHub usernames

    permissions_ignore: Ignore org-level teams to prevent Terraform drift

🔐 Branch Protection Rules

Applied automatically to the default branch (main, master, etc.):
Rule	Description
non_fast_forward	Prevents force pushes
require_code_owner_review	Code owners must approve
required_review_thread_resolution	Conversations must be resolved
require_last_push_approval	Last pusher cannot approve their own PR
required_linear_history	Disallows merge commits
required_signatures	Enforces GPG commit signing
required_approving_review_count	1 (private), 2 (public)
dismiss_stale_reviews_on_push	Revokes stale PR approvals on new commits
⚙️ Optional Enhancements
Feature	Description
workflow_wiz-iac	Deploys Wiz IaC Scanner GitHub Action
template_pull_request	Adds a .github/pull_request_template.md
property_audit_scope	Sets custom GitHub property for auditing
property_product_code	Adds metadata for product tagging
custom_properties	Extend repository metadata with custom property sets
📚 Dependencies
Tool	Version
Terraform	>= 0.13.0
GitHub Provider	>= 6.0.0

    ✅ Auth is handled through a GitHub App (e.g. CloudAuto-Terraform-GitHub) using environment variables set per workspace.

