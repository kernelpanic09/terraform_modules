# AWS OIDC Integration for Terraform Cloud

This Terraform module configures AWS IAM to support OpenID Connect (OIDC) authentication from Terraform Cloud. It automates creation of the OIDC provider and IAM roles, enabling secure, scalable workload identity federation across multiple Terraform workspaces.

## Features

- Creates an AWS IAM OIDC provider for Terraform Cloud
- Dynamically provisions IAM roles per workspace
- Generates scoped trust policies with `aud` and `sub` claims
- Fully configurable via module inputs
- Supports opt-in/opt-out deployment toggles
STSaws cloud
## Architecture Overview

![image](https://github.com/user-attachments/assets/7fb5aff4-0925-4fbd-b565-5fdc66312200)


## Use Cases

- AWS authentication via Terraform Cloud's dynamic credentials
- Least-privilege IAM role scoping per project and workspace
- GitOps-style secure identity integration

## Requirements

- Terraform v1.3 or higher
- AWS account with IAM permissions
- Terraform Cloud organization and workspaces

## Module Usage

```hcl
module "aws_oidc" {
  source = "github.com/YOUR_GITHUB_USERNAME/aws-oidc"

  aws_config              = true
  tfc_hostname            = "app.terraform.io"
  tfc_org_name            = "my-org"
  tfc_aws_audience        = "aws.workload.identity"
  tfc_run_role_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  workspace_project_list = [
    {
      workspace_name = "dev"
      project_name   = "infra"
    },
    {
      workspace_name = "prod"
      project_name   = "platform"
    }
  ]
}
```

IAM Trust Policy Example

```bash
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::123456789012:oidc-provider/app.terraform.io"
  },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
    "StringEquals": {
      "app.terraform.io:aud": "aws.workload.identity"
    },
    "StringLike": {
      "app.terraform.io:sub": "organization:my-org:project:infra:workspace:dev:run_phase:*"
    }
  }
}
```


## Outputs

| Name                  | Description                                         |
|-----------------------|-----------------------------------------------------|
| `tfc_iam_role_arns`   | List of IAM role ARNs for each Terraform workspace  |
| `tfc_oidc_provider_arn` | ARN of the configured OIDC provider in AWS       |


Directory Tree
```bash
aws-oidc/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
```


This module is built as a DevOps automation artifact for secure and scalable cloud identity integration using Terraform Cloud and AWS.




