# Obtain a Public Certificate from Terraform Cloud
data "tls_certificate" "terraformcloud_cert" {
  count = var.aws_config ? 1 : 0
  url   = "https://${var.tfc_hostname}"
}

# Create the OpenID Provider using the Terraform Cloud public signing certificate's fingerprints
resource "aws_iam_openid_connect_provider" "aws_identity_provider" {
  count           = var.aws_config ? 1 : 0
  url             = data.tls_certificate.terraformcloud_cert[count.index].url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [for cert in data.tls_certificate.terraformcloud_cert[count.index].certificates : cert.sha1_fingerprint]
}

# Creating the IAM Service Role for TFC Dynamic Credentials
resource "aws_iam_role" "aws_role" {
  for_each           = { for w in local.workspace_project_list : w.workspace_name => w }
  name               = "terraform-oidc-${replace(each.value.workspace_name, "*", "")}"
  assume_role_policy = data.aws_iam_policy_document.tfc-assumerole_policydoc[each.value.workspace_name].json
  path               = var.tfe_iam_role_path
}

# Privileges Assigned to IAM Service Role for Terraform (defaults to Admin)
resource "aws_iam_role_policy_attachment" "aws-role-policy_attach" {
  for_each   = { for w in local.workspace_project_list : w.workspace_name => w }
  role       = aws_iam_role.aws_role[each.value.workspace_name].name
  policy_arn = var.tfc_run_role_policy_arn
}

# Assume Policy Document for IAM Role for Terraform Cloud to drive
data "aws_iam_policy_document" "tfc-assumerole_policydoc" {
  for_each   = { for w in local.workspace_project_list : w.workspace_name => w }
  statement {
    sid    = "TerraformDynamicCredsAssumption"
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${aws_iam_openid_connect_provider.aws_identity_provider[0].arn}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.tfc_hostname}:aud"
      values   = ["${one(aws_iam_openid_connect_provider.aws_identity_provider[0].client_id_list)}"]
    }
    condition {
      test     = "StringLike"
      variable = "${var.tfc_hostname}:sub"
      values = ["organization:${var.tfc_org_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:*"]
    }
  }
}
