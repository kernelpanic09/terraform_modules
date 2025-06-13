data "tfe_workspace_ids" "predefined" {
  for_each     = var.predefined_access
  names        = each.value
  organization = var.organization
}

data "tfe_workspace_ids" "custom" {
  count        = length(var.custom_access)
  names        = var.custom_access[count.index].workspaces
  organization = var.organization
}

locals {
  predefined_workspace_access = merge([
    for access_level, workspace_ids in data.tfe_workspace_ids.predefined : {
      for id in values(workspace_ids.ids) : id => access_level
    }
  ]...)

  custom_workspace_access = merge([
    for index, workspace_ids in data.tfe_workspace_ids.custom : {
      for id in values(workspace_ids.ids) : id => var.custom_access[index].permissions
    }
  ]...)
}

resource "tfe_team" "team" {
  name         = var.team_name
  organization = var.organization
}

resource "tfe_team_access" "predefined_access" {
  for_each     = local.predefined_workspace_access
  team_id      = tfe_team.team.id
  workspace_id = each.key
  access       = each.value
}

resource "tfe_team_access" "custom_access" {
  for_each     = local.custom_workspace_access
  team_id      = tfe_team.team.id
  workspace_id = each.key

  permissions {
    runs              = each.value.runs
    variables         = each.value.variables
    state_versions    = each.value.state_versions
    sentinel_mocks    = each.value.sentinel_mocks
    workspace_locking = each.value.workspace_locking
    run_tasks         = each.value.run_tasks
  }
}
