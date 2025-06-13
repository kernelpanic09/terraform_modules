# This module is intended to easily create all requisite resources and configurations required to enable a Terraform Cloud Workspace to utilize OIDC authentication, thereby obviating the need for static AWS keys to be associated with this account. It also has been extended to provide the ability to generate resources for an OIDC integration with CircleCi.

Module Input Variables
There are no required input values for the successful execution of this module. All parameters are self-derived at run-time.

Dependencies
AWS Provider >= 3.4.0
Terraform >= 0.12.0
Prerequisites
The implementation of this module, alone, is not enough to convert the terraform workspace or CircleCi project to use OIDC authentication. Additional Workspace environment variables are also required.

For Terraform the module, and it's subsequent resources may be processed at any time, but the functional change to utilizing OIDC is not effected until both variables have been created, with the TFC_AWS_PROVIDER_AUTH variable needing to be set to TRUE to conclusively implement the change to OIDC.

These variables may be created manually through the UI, or programatically using API calls or even via the TFE Provider for Terraform. The method is up to you, but the final hand-off to using OIDC is not complete until both of teh following are set.

Terraform Workspace Environment Variables NOTE: None of these are considered sensitive!

AWS_ACCOUNT_NUMBER: The numerical AWS account identifier which is assocaited with this Terraform Cloud Workspace.
TFC_AWS_RUN_ROLE_ARN: An AWS ARN value which represents the IAM role designated as the user context under which Terraform Cloud will operate this workspace.
TFC_AWS_PROVIDER_AUTH: This is a simple booleean true/false which toggles Terraform Cloud's use of OIDC credentials versus a static keypair.
Terraform Cloud Private Registry


Usage
Simply add a block to an existing Terraform file, or create a new file named oidc.tf and paste the following. Note the version number and always use the latest, greatest version published to the Private Registry!

module "oidc" {
  source  = "app.terraform.io/<registry>/oidc/tfc"
  version = "0.X.Y"

  tfc_oidc = true
  cci_oidc = false
}
Outputs
tfc-openid-provider: json metadata about the OIDC Provider created in IAM for Terraform Cloud
tfc-service-role: the IAM role which the user-context for this Terraform Cloud Workspace
cci-openid-provider: json metadata about the OIDC Provider created in IAM for CircleCi
cci-service-role: the IAM role which the user-context for this CircleCi Project
