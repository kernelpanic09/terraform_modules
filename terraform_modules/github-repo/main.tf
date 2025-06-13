terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}

locals {
  teams_engineering_admins = [
    "cso-leadership",
    "incident-commanders",
    "principal-engineers",
  ]
  teams_engineering_writers = [
    "customer-security-operations",
    "engineering",
  ]
  teams_engineering_readers = [
  ]
  teams_engineering_maintainers = [
    "staff-engineers",
  ]
  teams_trust_admins = [
    "it-leadership",
  ]
  teams_trust_writers = [
    "corporate-security",
  ]
  teams_trust_readers = [
  ]
  teams_trust_maintainers = [
    "it-support",
    "systems-engineering",
  ]

  # Maintain a highest common denomintaor list, since you cannot assign two
  # permissions to the same team on the same repositoriy.
  # 'product-security' is both a writer in trust, and a reader in engineering
  # so a merge will not work if both Engineering and Trust permissions are enabled!
  teams_combined_admins      = compact(concat(tolist(local.teams_engineering_admins), tolist(local.teams_trust_admins)))
  teams_combined_writers     = compact(concat(tolist(local.teams_engineering_writers), tolist(local.teams_trust_writers)))
  teams_combined_maintainers = compact(concat(tolist(local.teams_engineering_maintainers), tolist(local.teams_trust_maintainers)))
  teams_combined_readers     = compact(concat(tolist([])))
}

resource "github_repository" "this" {
  archived               = var.archived
  allow_auto_merge       = var.allow_auto_merge
  allow_merge_commit     = var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge
  allow_update_branch    = var.allow_update_branch
  auto_init              = var.auto_init
  delete_branch_on_merge = var.delete_branch_on_merge
  description            = var.description
  gitignore_template     = var.gitignore_template
  has_downloads          = var.has_downloads
  has_issues             = var.has_issues
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  homepage_url           = var.homepage_url
  merge_commit_message   = var.merge_commit_message
  merge_commit_title     = var.merge_commit_title
  name                   = var.repository_name
  dynamic "pages" {
    for_each = var.pages_source_path != null ? [var.pages_source_path] : []
    content {
      build_type = var.pages_build_type
      cname      = var.pages_cname
      source {
        branch = var.pages_source_branch
        path   = var.pages_source_path
      }
    }
  }
  squash_merge_commit_message = var.squash_merge_commit_message
  squash_merge_commit_title   = var.squash_merge_commit_title
  dynamic "template" {
    for_each = var.template_repository != null ? [var.template_repository] : []
    content {
      include_all_branches = var.template_include_all_branches
      owner                = var.template_owner
      repository           = var.template_repository
    }
  }
  visibility                  = var.repository_visibility
  vulnerability_alerts        = var.vulnerability_alerts
  web_commit_signoff_required = var.web_commit_sign_off_required
}

resource "github_branch" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = github_branch.this.branch
}

resource "github_repository_ruleset" "this" {
  name        = "infosec-requirements"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = var.bootstrap ? "disabled" : "active"

  conditions {
    ref_name {
      include = [
        "~DEFAULT_BRANCH",
      ]
      exclude = []
    }
  }

  rules {
    non_fast_forward = var.no_bypass
    pull_request {
      dismiss_stale_reviews_on_push     = var.dismiss_stale
      require_code_owner_review         = var.require_codeowner_review
      require_last_push_approval        = var.require_last_push_approval
      required_approving_review_count   = (var.repository_visibility == "private" ? 1 : 2)
      required_review_thread_resolution = var.require_conversation_resolution
    }
    required_linear_history = var.require_linear_history
    required_signatures     = var.require_code_signing
    update                  = var.allow_bypass_update
  }
}

resource "github_repository_collaborators" "this" {
  repository = github_repository.this.name
  dynamic "team" {
    for_each = var.permissions_engineering ? (var.permissions_trust ? compact(concat(var.repository_admins_teams, tolist(local.teams_combined_admins))) : compact(concat(var.repository_admins_teams, tolist(local.teams_engineering_admins)))) : var.permissions_trust ? compact(concat(var.repository_admins_teams, tolist(local.teams_trust_admins))) : var.repository_admins_teams
    content {
      permission = "admin"
      team_id    = team.value
    }
  }
  dynamic "user" {
    for_each = var.repository_admins_users
    content {
      permission = "admin"
      username   = user.value
    }
  }
  dynamic "team" {
    for_each = var.permissions_engineering ? (var.permissions_trust ? compact(concat(var.repository_maintainers_teams, tolist(local.teams_combined_maintainers))) : compact(concat(var.repository_maintainers_teams, tolist(local.teams_engineering_maintainers)))) : var.permissions_trust ? compact(concat(var.repository_maintainers_teams, tolist(local.teams_trust_maintainers))) : var.repository_maintainers_teams
    content {
      permission = "maintain"
      team_id    = team.value
    }
  }
  dynamic "user" {
    for_each = var.repository_maintainers_users
    content {
      permission = "maintain"
      username   = user.value
    }
  }
  dynamic "team" {
    for_each = var.permissions_engineering ? (var.permissions_trust ? compact(concat(var.repository_readers_teams, tolist(local.teams_combined_readers))) : compact(concat(var.repository_readers_teams, tolist(local.teams_engineering_readers)))) : var.permissions_trust ? compact(concat(var.repository_readers_teams, tolist(local.teams_trust_readers))) : var.repository_readers_teams
    content {
      permission = "pull"
      team_id    = team.value
    }
  }
  dynamic "user" {
    for_each = var.repository_readers_users
    content {
      permission = "pull"
      username   = user.value
    }
  }
  dynamic "team" {
    for_each = var.permissions_engineering ? (var.permissions_trust ? compact(concat(var.repository_writers_teams, tolist(local.teams_combined_writers))) : compact(concat(var.repository_writers_teams, tolist(local.teams_engineering_writers)))) : var.permissions_trust ? compact(concat(var.repository_writers_teams, tolist(local.teams_trust_writers))) : var.repository_writers_teams
    content {
      permission = "push"
      team_id    = team.value
    }
  }
  dynamic "user" {
    for_each = var.repository_writers_users
    content {
      permission = "push"
      username   = user.value
    }
  }
  dynamic "team" {
    for_each = var.repository_triage_teams
    content {
      permission = "triage"
      team_id    = team.value
    }
  }
  dynamic "user" {
    for_each = var.repository_triage_users
    content {
      permission = "triage"
      username   = user.value
    }
  }
  dynamic "ignore_team" {
    for_each = var.permissions_ignore
    content {
      team_id = ignore_team.value
    }
  }
}

resource "null_resource" "wiz-iac-replace" {
  count = var.workflow_wiz-iac ? 1 : 0
  triggers = {
    "wiz-iac" = filesha256(var.workflow_wiz-iac_file)
  }
}

resource "null_resource" "pull-request-template-replace" {
  count = var.template_pull_request ? 1 : 0
  triggers = {
    pull-request-template = filesha256(var.template_pull_request_file)
  }
}

resource "github_repository_file" "workflow_wiz-iac" {
  count = var.workflow_wiz-iac ? 1 : 0

  autocreate_branch               = true
  autocreate_branch_source_branch = var.default_branch
  branch                          = "infosec_wiz-iac_workflow"
  commit_message                  = "Wiz IaC Scanner Deployment & Configuration"
  content                         = file(var.workflow_wiz-iac_file)
  file                            = ".github/workflows/wiz-iac.yml"
  overwrite_on_create             = true
  repository                      = github_repository.this.name

  lifecycle {
    replace_triggered_by = [
      null_resource.wiz-iac-replace[count.index],
    ]
  }
}

resource "github_repository_pull_request" "infosec-wiziac-workflow" {
  count = var.workflow_wiz-iac ? 1 : 0

  base_ref        = var.default_branch
  base_repository = github_repository.this.name
  body            = ""
  head_ref        = github_repository_file.workflow_wiz-iac[count.index].ref
  title           = "[INFOSEC-WIZ] Wiz IaC Scanner Workflow"

  lifecycle {
    ignore_changes = [
      head_ref,
    ]
    replace_triggered_by = [
      github_repository_file.workflow_wiz-iac[count.index],
      null_resource.wiz-iac-replace,
    ]
  }

  depends_on = [
    github_repository_file.workflow_wiz-iac,
  ]
}

resource "github_repository_file" "pull_request_template" {
  count = var.template_pull_request ? 1 : 0

  autocreate_branch   = true
  branch              = "infosec_pr_template"
  commit_message      = "Pull Request template"
  content             = file(var.template_pull_request_file)
  file                = ".github/pull_request_template.md"
  overwrite_on_create = true
  repository          = github_repository.this.name

  lifecycle {
    replace_triggered_by = [
      null_resource.pull-request-template-replace[count.index],
    ]
  }
}

resource "github_repository_pull_request" "infosec-pr-template" {
  count = var.template_pull_request ? 1 : 0

  base_ref        = var.default_branch
  base_repository = github_repository.this.name
  body            = ""
  head_ref        = github_repository_file.pull_request_template[count.index].ref
  title           = "[INFOSEC-PRT] Pull Request Template"

  lifecycle {
    ignore_changes = [
      head_ref,
    ]
    replace_triggered_by = [
      github_repository_file.pull_request_template[count.index],
      null_resource.pull-request-template-replace,
    ]
  }

  depends_on = [
    github_repository_file.pull_request_template,
  ]
}

resource "github_repository_custom_property" "managed" {
  property_name  = "managed"
  property_type  = "true_false"
  property_value = ["true"]
  repository     = github_repository.this.name
}

resource "github_repository_custom_property" "audit_scope" {
  property_name = "audit_scope"
  property_type = "true_false"
  property_value = [
    var.property_audit_scope,
  ]
  repository = github_repository.this.name
}

resource "github_repository_custom_property" "product_code" {
  property_name = "product_code"
  property_type = "true_false"
  property_value = [
    var.property_product_code,
  ]
  repository = github_repository.this.name
}
