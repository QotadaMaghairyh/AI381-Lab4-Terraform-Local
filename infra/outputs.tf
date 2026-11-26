output "app_url" {
  description = "Local application URL; available after a successful deployment."
  value       = "http://127.0.0.1:${var.published_port}"
}

output "health_url" {
  description = "Endpoint for a subsequent application smoke test."
  value       = "http://127.0.0.1:${var.published_port}/health"
}

output "container_name" {
  description = "Name of the container managed by this configuration."
  value       = docker_container.api.name
}
