# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = false
}

# Create a subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.environment}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Create a firewall rule
resource "google_compute_firewall" "allow_ssh_http" {
  name    = "${var.environment}-allow-ssh-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = var.allowed_cidr_blocks
  target_tags   = ["web-server"]
}

# Create a service account
resource "google_service_account" "instance_sa" {
  account_id   = "${var.environment}-instance-sa"
  display_name = "Service Account for ${var.environment} instances"
}

# Create a GCE instance
resource "google_compute_instance" "web_server" {
  name         = "${var.environment}-web-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = var.image_family
      size  = var.disk_size
      type  = var.disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    
    access_config {
      # Ephemeral public IP
    }
  }

  service_account {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = var.startup_script

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}

# Create a static IP (optional)
resource "google_compute_address" "static_ip" {
  count = var.create_static_ip ? 1 : 0
  name  = "${var.environment}-static-ip"
}

# Attach static IP to instance if created
resource "google_compute_instance" "web_server_with_static_ip" {
  count        = var.create_static_ip ? 1 : 0
  name         = "${var.environment}-web-server-static"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = var.image_family
      size  = var.disk_size
      type  = var.disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    
    access_config {
      nat_ip = google_compute_address.static_ip[0].address
    }
  }

  service_account {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = var.startup_script

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}