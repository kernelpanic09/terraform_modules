# terraform_modules🌿 terraform_modules

A collection of curated Terraform modules designed to support secure, scalable, and modular infrastructure-as-code practices across AWS, Azure, GCP, GitHub, and more. Ideal for organizations adopting policy-driven, reusable automation in Terraform.
🧭 Repository Structure

Each subdirectory under modules/ represents a standalone Terraform module:

terraform_modules/
├── aws_organization/
├── github_repository/
├── gcp_oidc/
├── azure_oidc/
├── s3_bucket/
├── workspaces/
└── sso_account_assignment/

Each module is fully documented and intended to serve as a building block in larger infrastructure compositions.
🚀 Getting Started

    Clone this repository

git clone https://github.com/kernelpanic09/terraform_modules.git
cd terraform_modules

Use a module in your Terraform config

module "my_github_repo" {
  source  = "./modules/github_repository"
  version = "1.0.0"

  repository_name       = "my-app"
  repository_visibility = "private"
  permissions_engineering = true
  workflow_wiz_iac      = true
}

Init & apply

    terraform init
    terraform apply

🔐 Available Modules
Module	Description
aws_organization/	Manages AWS Organization structure, including OUs, accounts, and SCPs
github_repository/	Creates GitHub repos with branch protection, workflows, and team access
gcp_oidc/	Enables Terraform Cloud OIDC setup for GCP using Workload Identity Federation
azure_oidc/	Sets up OIDC-based authentication between Terraform Cloud and Azure AD
s3_bucket/	Deploys secure, versioned AWS S3 buckets with encryption and lifecycle rules
workspaces/	Automates Terraform Cloud workspace creation with multi-cloud OIDC support
sso_account_assignment/	Automates AWS IAM Identity Center (SSO) account assignments to users/groups
📦 Requirements

    Terraform ≥ 0.13

    Providers as listed in each module's docs (e.g., AWS ≥ 3.45, GitHub ≥ 6.0, AzureAD ≥ 3.x, Google ≥ 5.x)

📝 Usage Example

To create a secure private GitHub repository with baseline workflows and permissions:

module "secure_repo" {
  source  = "./modules/github_repository"
  version = "1.0.0"

  repository_name         = "secure-app"
  repository_visibility   = "private"
  default_branch          = "main"
  permissions_engineering = true
  workflow_wiz_iac        = true
  template_pull_request   = true
}

🛡️ Security & Best Practices

    Principle of least privilege: permissions are minimal by default

    Baseline branch protection and commit signing enforced

    OIDC modules support a two-phased bootstrap transition from static to dynamic credentials

    Modules are composable and reusable across environments

📚 Documentation & Examples

    Module-level docs: Each folder includes a README.md with usage, inputs, outputs, and examples

    Example configurations: examples/ subfolders illustrate real-world use cases per module

⚙️ Contributing

    ✅ PRs welcome for new modules, improvements, bugfixes

    🔄 Follow the style and module documentation conventions

    📋 Ensure modules include full input/output descriptions and have automated testing where possible