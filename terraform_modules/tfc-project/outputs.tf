output "project_id" {
  value       = tfe_project.project.id
  description = "ID of the created Terraform Cloud project"
}


output "project_summary" {
  description = "Summary of the created project and team access"
  value = {
    project_name = tfe_project.project.name
    project_id   = tfe_project.project.id
    organization = data.tfe_organization.org.name
    team_access = {
      for team, access in var.team_access : team => {
        access_level     = access.access
        project_access   = access.project_access != null ? access.project_access : null
        workspace_access = access.workspace_access != null ? access.workspace_access : null
      }
    }
  }
}
