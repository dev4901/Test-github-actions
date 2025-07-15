# outputs.tf
output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.web_server.name
}

output "instance_external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}

output "instance_internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.web_server.network_interface[0].network_ip
}

output "instance_zone" {
  description = "Zone of the created instance"
  value       = google_compute_instance.web_server.zone
}

output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.instance_sa.email
}

output "static_ip_address" {
  description = "Static IP address (if created)"
  value       = var.create_static_ip ? google_compute_address.static_ip[0].address : null
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh ${var.ssh_user}@${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}"
}