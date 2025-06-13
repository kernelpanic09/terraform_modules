output "default_branch" {
  description = "Name of the repository default branch."
  value       = github_branch_default.this.branch
}

output "repository_collaborators" {
  description = "Teams to ignore for permissions, typically due to receiving permissions at the Organizational layer."
  value       = github_repository_collaborators.this
}

output "repository_name" {
  description = "Name of the repository."
  value       = github_repository.this.name
}

output "repository_node_id" {
  description = "GraphQL global node id of the repository, for use with v4 API."
  value       = github_repository.this.node_id
}
