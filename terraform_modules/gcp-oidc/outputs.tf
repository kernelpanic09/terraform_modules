output "gcp_identity_pool_id" {
  description = <<EOF
  An identifier for the ID pool in the format:
  projects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}
  EOF
  value       = google_iam_workload_identity_pool.gcp_id_pool.id
}
output "gcp_identity_pool_provider_id" {
  description = <<EOF
  An identifier for the ID pool provider in the format:
  projects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}/providers/{{workload_identity_pool_provider_id}}
  EOF
  value       = toset([for prov_id in google_iam_workload_identity_pool_provider.tfc_provider : prov_id.id])
}
output "gcp_service_account_name" {
  description = <<EOF
  An identifer for the service account in the format:
  projects/{{project}}/serviceAccounts/{{email}}
  EOF
  value       = toset([for acct_id in google_service_account.tfc_service_account : acct_id.id])
}
output "gcp_service_account_email" {
  description = "The email addresss of the service account being used to authenticate this Terraform Workspace."
  value       = toset([for email_addr in google_service_account.tfc_service_account : email_addr.email])
}
output "gcp_project_id" {
  description = "The numeric identifier of the GCP project being interfaced with."
  value       = data.google_project.gcp_project.number
}
output "gcp_workload_id_pool_provider_name" {
  description = <<EOF
  Resource name of the provider pool as:
  projects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}/providers/{{workload_identity_pool_provider_id}}
  This value should be used for TFC_GCP_WORKLOAD_PROVIDER_NAME environment variable on the Terraform Workspace.
  EOF
  value       = toset([for acct_name in google_iam_workload_identity_pool_provider.tfc_provider : acct_name.name])
}
