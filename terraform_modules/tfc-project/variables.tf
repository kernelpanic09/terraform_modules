variable "organization_name" {
  type        = string
  description = "Name of the Terraform Cloud organization"
  default     = "orgname"
}

variable "project_name" {
  type        = string
  description = "Name of the Terraform Cloud project"
}

variable "team_access" {
  type = map(object({
    access = string
    project_access = optional(object({
      settings = optional(string)
      teams    = optional(string)
    }))
    workspace_access = optional(object({
      state_versions = optional(string)
      sentinel_mocks = optional(string)
      runs           = optional(string)
      variables      = optional(string)
      create         = optional(bool)
      locking        = optional(bool)
      move           = optional(bool)
      delete         = optional(bool)
      run_tasks      = optional(bool)
    }))
  }))
  description = "Map of team names to their access levels and custom permissions for the project"
  default     = {}
}
