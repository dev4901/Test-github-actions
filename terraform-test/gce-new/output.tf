# outputs.tf
output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.web_server.name
}

output "instance_internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.web_server.network_interface[0].network_ip
}

output "instance_zone" {
  description = "Zone of the created instance"
  value       = google_compute_instance.web_server.zone
}