# Terraform Cloud Teams Module

This Terraform module allows you to create and manage teams within a Terraform Cloud organization, along with their access to workspaces. It provides flexibility in defining both predefined and custom access patterns for workspaces.

## Features

- Create a new team in your Terraform Cloud organization
- Assign predefined access levels (read, plan, write, admin) to workspaces matching specific patterns
- Define custom access permissions for workspaces with granular control over various permission types

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables:

```hcl
module "tfe_team_example" {
  source       = "app.terraform.io/orgname/rc-team/tfc"
  team_name    = "Example-Team"

  predefined_access = {
    read  = ["prod-*", "staging-*"]
    write = ["dev-*"]
  }

  custom_access = [
    {
      workspaces = ["okta-*"]
      permissions = {
        runs              = "plan"
        variables         = "read"
        state_versions    = "read-outputs"
        sentinel_mocks    = "read"
        workspace_locking = true
        run_tasks         = false
      }
    }
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| tfe  | >= 0.56.0 |


## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `team_name` | The name of the team to create | `string` | - |
| `predefined_access` | Map of predefined access levels to lists of workspace patterns | `map(list(string))` | `{}` |
| `custom_access` | List of custom access configurations | `list(object)` | `[]` |


## Outputs

| Name | Description |
|------|-------------|
| `team_id` | The ID of the created team |
| `predefined_matching_workspaces` | Map of predefined access levels to lists of matching workspace names |
| `custom_matching_workspaces` | List of lists of workspace names matching custom access patterns |
| `predefined_access_summary` | Summary of predefined access assignments |
| `custom_access_summary` | Summary of custom access assignments |


## Notes

- Ensure that the workspace patterns you provide exist in your Terraform Cloud organization.
- Be cautious when assigning high-level permissions (like `admin`) to ensure security best practices.
- Custom permissions allow for more granular control but require careful configuration.
