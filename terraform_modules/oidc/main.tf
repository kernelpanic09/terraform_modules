module "aws_oidc" {
  source = "./aws-oidc"
  count  = var.tfc_oidc ? 1 : 0
}

module "cci_oidc" {
  source = "./cci-oidc"
  count  = var.cci_oidc ? 1 : 0
}

module "azure_oidc" {
  source             = "./azure-oidc"
  count              = ((var.azure_oidc) && (length(var.azure_app_reg_name) > 0)) ? 1 : 0
  azure_app_reg_name = var.azure_app_reg_name
}

module "gcp_oidc" {
  source         = "./gcp-oidc"
  count          = ((var.gcp_oidc) && (length(var.gcp_project_id) > 0)) ? 1 : 0
  gcp_project_id = var.gcp_project_id
}
