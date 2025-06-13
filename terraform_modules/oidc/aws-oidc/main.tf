# Obtain a Public Certificate from Terraform Cloud
data "tls_certificate" "terraformcloud_cert" {
  url = "https://${var.tfc_hostname}"
}

# Create the OpenID Provider using the Terraform Cloud public signing certificate's fingerprints
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.terraformcloud_cert[count.index].url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [for cert in data.tls_certificate.terraformcloud_cert[count.index].certificates : cert.sha1_fingerprint]
}

# Creating the IAM Service Role for TFC Dynamic Credentials
resource "aws_iam_role" "tfc_role" {
  name               = var.tfc_role_name
  assume_role_policy = data.aws_iam_policy_document.tfc-assumerole_policydoc[count.index].json
}

# Privileges Assigned to IAM Service Role for Terraform (defaults to Admin)
resource "aws_iam_role_policy_attachment" "tfc-role-policy_attach" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = var.tfc_run_role_policy_arn
}

# Assume Policy Document for IAM Role for Terraform Cloud to drive
data "aws_iam_policy_document" "tfc-assumerole_policydoc" {
  statement {
    sid    = "TerraformDynamicCredsAssumption"
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${aws_iam_openid_connect_provider.tfc_provider.arn}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.tfc_hostname}:aud"
      values   = ["${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"]
    }
    condition {
      test     = "StringLike"
      variable = "${var.tfc_hostname}:sub"

      # This may be more tightly constrained via named workspaces and/or projects
      values = ["organization:${var.tfc_org_name}:project:*:workspace:*:run_phase:*"]
    }
  }
}
