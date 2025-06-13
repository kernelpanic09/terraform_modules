🔐 AWS SSO Account Assignment Terraform Module

This module automates the assignment of AWS IAM Identity Center (formerly AWS SSO) permission sets to users and groups within a specified AWS account.

It creates the following resources:

    aws_ssoadmin_account_assignment

This is useful for managing centralized IAM Identity Center access using Infrastructure as Code.
🚀 Features

    Dynamically discovers your AWS SSO instance and identity store

    Supports assignment of permission sets to users, groups, or both

    Accepts display names (not IDs) for users and groups

    Returns output metadata for audit and traceability

🧰 Requirements
Name	Version
Terraform	≥ 0.15
AWS	≥ 3.45
📦 Providers
Name	Version
aws	≥ 3.49
📥 Inputs
Name	Description	Type	Default	Required
account_id	AWS Account ID to assign permissions to (10–12 digits)	string	—	✅
permission_set_arn	ARN of the IAM Identity Center permission set	string	—	✅
groups	List of group display names to assign the permission set to	list(string)	[]	❌
users	List of user names to assign the permission set to	list(string)	[]	❌
📤 Outputs
Name	Description
account_id	Target AWS account ID
instance_arn	ARN of the discovered IAM Identity Center instance
identity_store_id	Identity store ID linked to the SSO instance
permission_set	ARN of the assigned permission set
group_assignments	List of successfully assigned groups
user_assignments	List of successfully assigned users
name	Unique name string combining account and permission set
🧩 Example Usage

module "sso_account_assignment" {
  source = "app.terraform.io/orgname/sso-account-assignment/aws"
  version = "0.1.1"

  account_id         = "123456789012"
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-abc1234567890123/ps-9876543210abcdef"
  groups             = ["engineering-admins", "platform-readers"]
  users              = ["jane.doe@example.com", "john.smith@example.com"]
}

🔍 How It Works

    Automatically discovers the SSO instance and identity store

    Uses group DisplayName and user UserName to resolve identity store IDs

    Assigns the specified permission set to all listed groups and users

    Stores assignment metadata in a locals block for traceability

⚙️ Internals
Discovered Resources

    data.aws_ssoadmin_instances – Lists available SSO instances

    data.aws_identitystore_group – Resolves group names to identity store IDs

    data.aws_identitystore_user – Resolves user names to identity store IDs

    data.aws_ssoadmin_permission_set – Confirms the permission set ARN

Created Resources

    aws_ssoadmin_account_assignment.groups – Assigns groups

    aws_ssoadmin_account_assignment.users – Assigns users