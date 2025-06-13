AWS OIDC & CircleCI Terraform Module

This Terraform module provisions all the necessary AWS resources to enable secure OIDC (OpenID Connect) authentication between:

    Terraform Cloud (TFC) and AWS

    Optionally: CircleCI and AWS

This setup eliminates the need for long-lived AWS access keys and enables dynamic, short-lived credentials for secure access control.
📦 Dependencies

    Terraform ≥ 0.12.0

    AWS Provider ≥ 3.4.0

⚙️ Prerequisites

This module only provisions AWS-side resources. To complete the OIDC setup, you must also configure specific Terraform Cloud Workspace Environment Variables:
Variable	Description
TFC_AWS_RUN_ROLE_ARN	The full ARN of the IAM role that Terraform Cloud will assume using OIDC
TFC_AWS_PROVIDER_AUTH	Set this to "true" to enable OIDC-based provider authentication

    ⚠️ These variables are not sensitive and can be configured manually via the Terraform Cloud UI, API, or TFE provider.

☁️ Terraform Cloud Integration

When aws_config = true (default), this module:

    Fetches the Terraform Cloud public OIDC certificate

    Creates an AWS IAM OIDC provider

    Generates per-workspace IAM roles with trust policies tied to Terraform Cloud’s OIDC identity

    Optionally attaches a custom or default policy (e.g., AdministratorAccess)

🔁 CircleCI OIDC Integration (Optional)

To enable CircleCI integration:

    Set cci_config = true

    The module will:

        Create a separate OIDC provider for CircleCI

        Create a dedicated IAM role with a trust policy for CircleCI

        Attach the specified permissions

🚀 Usage Example

This example configures Terraform Cloud-only OIDC resources. CircleCI support is disabled by default (cci_config = false).

module "rc-awsoidc" {
  source  = "app.terraform.io/orgname/rc-awsoidc/aws"
  version = "0.X.Y" # Use the latest version available

  aws_config = true
  cci_config = false

  workspace_project_list = [
    {
      workspace_name = "my-new-workspace"
      project_name   = "Default Project"
    }
  ]
}

📄 Key Resources Created
Terraform Cloud OIDC Integration

    aws_iam_openid_connect_provider – Sets up AWS to trust Terraform Cloud's OIDC issuer

    aws_iam_role – Creates IAM roles for each specified workspace

    aws_iam_policy_document – Trust policy for OIDC assumption

    aws_iam_role_policy_attachment – Attaches the execution policy

# Example IAM role trust condition for TFC
condition {
  test     = "StringLike"
  variable = "${var.tfc_hostname}:sub"
  values   = ["organization:${var.tfc_org_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:*"]
}

✅ Final Steps

Once this module is applied:

    Set the following environment variables in Terraform Cloud:

        TFC_AWS_RUN_ROLE_ARN → IAM role ARN created by this module

        TFC_AWS_PROVIDER_AUTH → "true"

    Run a test plan to verify OIDC-based access is working