data "tfe_organization" "org" {
  name = var.organization_name
}

resource "tfe_project" "project" {
  name         = var.project_name
  organization = data.tfe_organization.org.name
}

resource "tfe_team_project_access" "team_access" {
  for_each   = var.team_access
  access     = each.value.access
  team_id    = data.tfe_team.teams[each.key].id
  project_id = tfe_project.project.id

  dynamic "project_access" {
    for_each = each.value.project_access != null ? [each.value.project_access] : []
    content {
      settings = project_access.value.settings
      teams    = project_access.value.teams
    }
  }

  dynamic "workspace_access" {
    for_each = each.value.workspace_access != null ? [each.value.workspace_access] : []
    content {
      state_versions = workspace_access.value.state_versions
      sentinel_mocks = workspace_access.value.sentinel_mocks
      runs           = workspace_access.value.runs
      variables      = workspace_access.value.variables
      create         = workspace_access.value.create
      locking        = workspace_access.value.locking
      move           = workspace_access.value.move
      delete         = workspace_access.value.delete
      run_tasks      = workspace_access.value.run_tasks
    }
  }
}

data "tfe_team" "teams" {
  for_each     = var.team_access
  name         = each.key
  organization = data.tfe_organization.org.name
}
