locals {
  circleci_oidc_url = "${var.cci_hostname}/org/${var.cci_org_id}"
  cci_role_value    = "org/${var.cci_org_id}/project/*/user/*"
}

# Obtain the CCI Signing Certificate
data "tls_certificate" "circleci_cert" {
  url = "https://${local.circleci_oidc_url}"
}

# Privileges Assigned to IAM Service Role for CircleCi (defaults to Power User)
resource "aws_iam_role_policy_attachment" "cci-role-policy_attach" {
  role       = aws_iam_role.cci_role.name
  policy_arn = var.cci_run_role_policy_arn
}

# Create the OpenID Provider using CircleCi public signing certificate's fingerprints
resource "aws_iam_openid_connect_provider" "cci_provider" {
  url             = "https://${local.circleci_oidc_url}"
  client_id_list  = [var.cci_org_id]
  thumbprint_list = [for cert in data.tls_certificate.circleci_cert[count.index].certificates : cert.sha1_fingerprint]
}

# Creating the IAM Service Role for CCI Dynamic Credentials
resource "aws_iam_role" "cci_role" {
  name               = var.cci_role_name
  assume_role_policy = data.aws_iam_policy_document.cci-assumerole_policydoc.json
}

# Assume Policy Document for IAM Role for CircleCi to drive
data "aws_iam_policy_document" "cci-assumerole_policydoc" {
  statement {
    sid    = "CircleCiDynamicCredsAssumption"
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${aws_iam_openid_connect_provider.cci_provider.arn}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.circleci_oidc_url}:aud"
      values   = [var.cci_org_id]
    }
    condition {
      test     = "StringLike"
      variable = "${local.circleci_oidc_url}:sub"
      values   = [local.cci_role_value]
    }
  }
}
