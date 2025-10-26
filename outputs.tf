output "release_name" {
  description = "Name of the installed Helm release"
  value       = helm_release.this.name
}

output "status" {
  description = "Helm release status"
  value       = helm_release.this.status
}

output "chart" {
  description = "Chart installed (name)"
  value       = helm_release.this.chart
}

output "version" {
  description = "Chart version installed"
  value       = helm_release.this.version
}
