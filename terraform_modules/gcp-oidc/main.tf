# Data source used to get the project number programmatically.
data "google_project" "gcp_project" {
}

# Enables the required services in the project.
resource "google_project_service" "gcp_services" {
  for_each           = toset(var.gcp_service_list)
  disable_on_destroy = false
  service            = each.key
}

# Creates a workload identity pool to house a workload identity pool provider.
resource "google_iam_workload_identity_pool" "gcp_id_pool" {
  workload_identity_pool_id = "terraform-oidc-${formatdate("YYYYMMDD-hhmm", timestamp())}"

  lifecycle {
    ignore_changes = [workload_identity_pool_id]
  }
}

# Creates an identity pool provider which uses an attribute condition
# to ensure that only the specified Terraform Cloud workspace will be
# able to authenticate to GCP using this provider.
resource "google_iam_workload_identity_pool_provider" "tfc_provider" {
  for_each                           = { for w in var.workspace_project_list : w.workspace_name => w }
  workload_identity_pool_id          = google_iam_workload_identity_pool.gcp_id_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = replace(replace(replace(replace(lower(each.value.workspace_name), " ", "-"), "_", "-"), "/^infrastructure-it-/", ""), "/^gcp-/", "google-")

  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${var.tfc_hostname}"
    # The default audience format used by TFC is of the form:
    # //iam.googleapis.com/projects/{project number}/locations/global/workloadIdentityPools/{pool ID}/providers/{provider ID}
    # which matches with the default accepted audience format on GCP.
    #
    # Uncomment the line below if you are specifying a custom value for the audience instead of using the default audience.
    # allowed_audiences = [var.tfc_gcp_audience]
  }
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_org_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}\")"
}

# Creates a service account that will be used for authenticating to GCP.
resource "google_service_account" "tfc_service_account" {
  for_each     = { for w in var.workspace_project_list : w.workspace_name => w }
  account_id   = join("-", ["tfc-oidc", replace(replace(replace(replace(lower(each.value.workspace_name), " ", "-"), "_", "-"), "/^infrastructure-it-/", ""), "/^gcp-/", "google-")])
  display_name = join("-", ["tfc-oidc", replace(replace(replace(replace(lower(each.value.workspace_name), " ", "-"), "_", "-"), "/^infrastructure-it-/", ""), "/^gcp-/", "google-")])
}

# Allows the service account to act as a workload identity user.
resource "google_service_account_iam_member" "tfc_service_account_member" {
  for_each           = { for w in var.workspace_project_list : w.workspace_name => w }
  service_account_id = google_service_account.tfc_service_account[each.value.workspace_name].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gcp_id_pool.name}/*"
}

# Updates the IAM policy to grant the service account permissions
# within the project.
resource "google_project_iam_member" "iam_editors_member" {
  for_each = google_service_account.tfc_service_account
  project  = data.google_project.gcp_project.project_id
  role     = "roles/editor"
  member   = "serviceAccount:${each.value.email}"
}
resource "google_project_iam_member" "iam_svc_acct_admins_member" {
  for_each = google_service_account.tfc_service_account
  project  = data.google_project.gcp_project.project_id
  role     = "roles/iam.serviceAccountAdmin"
  member   = "serviceAccount:${each.value.email}"
}
resource "google_project_iam_member" "iam_workload_id_pool_admins_member" {
  for_each = google_service_account.tfc_service_account
  project  = data.google_project.gcp_project.project_id
  role     = "roles/iam.workloadIdentityPoolAdmin"
  member   = "serviceAccount:${each.value.email}"
}
