AWS Organization Terraform Module

This Terraform module provides a flexible and structured way to manage an entire AWS Organization — including organizational units (OUs), accounts, and Service Control Policies (SCPs). It allows you to define your org hierarchy, provision AWS accounts, attach policies, and enable service access in a clean, scalable format.
🚀 Example Usage

The following example creates an organization with:

    SCPs: dev_control_access, deny_all

    Nested OUs: CoreOU with children (DevelopmentOU, StageOU, ProductionOU) and a separate SandboxOU

    AWS accounts placed in different OUs and assigned policies

module "aws_organization" {
  source  = "cyberlabrs/aws-organization/aws"
  version = "1.0.0"

  feature_set                   = "ALL"
  aws_service_access_principals = ["sso.amazonaws.com"]
  enabled_policy_types          = ["SERVICE_CONTROL_POLICY"]

  policies = [
    {
      name          = "dev_control_access",
      template_file = "./policies/scps/dev_control_access.json"
    },
    {
      name          = "deny_all",
      template_file = "./policies/scps/deny_all.json"
    }
  ]

  organizational_units = [
    {
      name     = "CoreOU",
      policies = [],
      children = [
        {
          name     = "DevelopmentOU",
          policies = ["dev_control_access"],
          children = []
        },
        {
          name     = "StageOU",
          policies = [],
          children = []
        },
        {
          name     = "ProductionOU",
          policies = [],
          children = []
        }
      ]
    },
    {
      name     = "SandboxOU",
      policies = [],
      children = []
    }
  ]

  accounts = [
    {
      name      = "AccountInRootOU",
      email     = "test+root@test.com",
      parent_id = "",
      policies  = ["deny_all"]
    },
    {
      name         = "Development",
      email        = "test+dev@test.com",
      parent_path  = "CoreOU/DevelopmentOU"
    },
    {
      name         = "Stage",
      email        = "test+stage@test.com",
      parent_path  = "CoreOU/StageOU"
    },
    {
      name         = "Production",
      email        = "test+shared@test.com",
      parent_path  = "CoreOU/ProductionOU"
    }
  ]
}

📘 Examples

    Complete Organization Example

📦 Requirements
Dependency	Version
Terraform	≥ 1.3
AWS Provider	≥ 4.60
🔧 Inputs

See Inputs Table below for full input reference. Highlights:

    feature_set – Must be ALL to enable SCPs and advanced features

    policies – List of JSON policy files to upload and apply

    organizational_units – Tree-like structure to define your OU hierarchy

    accounts – AWS accounts to create and organize (with optional policies)

🏗️ Resources Created

This module manages:

    AWS Organization root

    Organizational Units (up to 5 levels deep)

    Service Control Policies (SCPs)

    AWS accounts

    Policy attachments to OUs, accounts, or root

📤 Outputs
Output	Description
accounts	List of created accounts
organization_id	AWS Organization ID
organization_arn	AWS Organization ARN
organizational_units	Flattened list of OUs (including root)
policies	List of created SCPs
📚 Inputs

See the Terraform Registry Documentation for a complete list of input variables, including:

    aws_service_access_principals

    enabled_policy_types

    import_mode

    root_unit_policies

🧑‍💻 Authors

Module maintained by Nikola Kolovic with contributions from the CyberLab Team.
📄 License

This project is licensed under the Apache 2.0 License.