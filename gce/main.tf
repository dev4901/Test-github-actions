resource "google_compute_instance" "default" {
  # The name of the VM instance.
  name         = "my-first-vm-instance"

  # The machine type to use (e.g., e2-medium is a cost-effective choice).
  machine_type = "e2-medium"

  # The zone where the instance will be created. Must be in the same region
  # as the subnetwork.
  zone         = "us-central1-a"

  # The boot disk configuration. This specifies the OS image for the VM.
  boot_disk {
    initialize_params {
      # Using a Debian 11 image from the 'debian-cloud' project.
      image = "debian-cloud/debian-11"
    }
  }

  # The network interface configuration. This attaches the VM to our
  # previously created subnetwork.
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.instance_subnet.id

    # An access_config block is required to assign a public IP address.
    # Leave it empty `{}` for an ephemeral IP.
    access_config {}
  }

  # (Optional) Add tags to the instance for firewall rules or identification.
  tags = ["web", "dev"]

  # (Optional) Add metadata, like a startup script.
  # This script will install a simple NGINX web server.
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOT
}
