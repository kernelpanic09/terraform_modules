# Terraform Cloud Projects Module

This Terraform module creates and manages projects in Terraform Cloud, including team access configurations.

## Features

- Creates a Terraform Cloud project
- Configures team access to the project
- Supports custom access levels for teams
- Provides detailed output for created resources

## Usage

```hcl
module "tfe_project_example" {
  source = "app.terraform.io/orgname/rc-project/tfc"

  project_name      = "eaxmple-project"

  team_access = {
    "team1" = {
      access = "admin"
      project_access = {
        settings = ["delete", "update"]
        teams    = "manage"
      }
      workspace_access = {
        state_versions = "read"
        sentinel_mocks = "read"
        runs           = "apply"
        variables      = "write"
        create         = true
        locking        = true
        move           = true
        delete         = true
        run_tasks      = true
      }
    }
    "team2" = {
      access = "write"
    }
  }
}
```


## Providers

| Name | Version |
|------|---------|
| tfe  | >= 0.56.0 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_name | The name of the project to create | `string` | n/a | yes |
| team\_access | Map of team names to their access configurations | `map(object)` | `{}` | no |

For detailed information about the `team_access` variable structure, please refer to the `variables.tf` file.

## Outputs

| Name | Description |
|------|-------------|
| project\_id | ID of the created Terraform Cloud project |
| project\_summary | Summary of the created project and team access |

## Notes

- Ensure that the teams specified in `team_access` already exist in your Terraform Cloud organization.
- The module uses the Terraform Cloud provider, which should be configured with appropriate credentials.
