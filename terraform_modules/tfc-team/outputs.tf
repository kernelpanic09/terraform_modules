output "team_id" {
  description = "The ID of the created team"
  value       = tfe_team.team.id
}

output "predefined_matching_workspaces" {
  description = "Map of predefined access levels to lists of matching workspace names"
  value = {
    for access, workspace in data.tfe_workspace_ids.predefined : access => values(workspace.full_names)
  }
}

output "custom_matching_workspaces" {
  description = "List of lists of workspace names matching custom access patterns"
  value       = [for workspace in data.tfe_workspace_ids.custom : values(workspace.full_names)]
}

output "predefined_access_summary" {
  description = "Summary of predefined access assignments"
  value = {
    for access, workspaces in data.tfe_workspace_ids.predefined : access => {
      workspace_names = values(workspaces.full_names)
      access_level    = access
    }
  }
}

output "custom_access_summary" {
  description = "Summary of custom access assignments"
  value = [
    for index, workspaces in data.tfe_workspace_ids.custom : {
      workspace_names = values(workspaces.full_names)
      permissions     = var.custom_access[index].permissions
    }
  ]
}
