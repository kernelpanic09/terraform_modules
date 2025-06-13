output "gcp_identity_pool_id" {
  description = "An identifier for the ID pool in the format:\nprojects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}"
  value       = google_iam_workload_identity_pool.gcp_id_pool.id
}

output "gcp_identity_pool_provider_id" {
  description = "An identifier for the ID pool provider in the format:\nprojects/{{project}}/locations/global/workloadIdentityPools/{{workload_identity_pool_id}}/providers/{{workload_identity_pool_provider_id}}"
  value       = google_iam_workload_identity_pool_provider.tfc_provider.id
}

output "gcp_service_account_id" {
  description = "An identifer for the service account in the format:\nprojects/{{project}}/serviceAccounts/{{email}}"
  value       = google_service_account.tfc_service_account.id
}

output "gcp_service_account_email" {
  description = "The email addresss of the service account."
  value       = google_service_account.tfc_service_account.email
}

output "gcp_service_account_name" {
  description = "The fully qualified name of the service account"
  value       = google_service_account.tfc_service_account.name
}
