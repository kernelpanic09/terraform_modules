variable "organization" {
  description = "The name of the organization"
  type        = string
  default     = "orgname"
}

variable "team_name" {
  description = "The name of the team to create"
  type        = string
}

variable "predefined_access" {
  description = "Map of predefined access levels to lists of workspaces"
  type        = map(list(string))
  default     = {}

  validation {
    condition = alltrue([
      for k in keys(var.predefined_access) :
      contains(["read", "plan", "write", "admin"], k)
    ])
    error_message = "Predefined access level must be one of 'read', 'plan', 'write', or 'admin'."
  }
}

variable "custom_access" {
  description = "List of custom access configurations"
  type = list(object({
    workspaces = list(string)
    permissions = object({
      runs              = string
      variables         = string
      state_versions    = string
      sentinel_mocks    = string
      workspace_locking = bool
      run_tasks         = bool
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for v in var.custom_access :
      contains(["read", "plan", "apply", "admin"], v.permissions.runs) &&
      contains(["none", "read", "write"], v.permissions.variables) &&
      contains(["none", "read", "read-outputs", "write"], v.permissions.state_versions) &&
      contains(["none", "read"], v.permissions.sentinel_mocks)

    ])
    error_message = "Invalid permissions specified for custom access."
  }
}
