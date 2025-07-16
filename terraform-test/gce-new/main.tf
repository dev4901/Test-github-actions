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

# Create a GCE instance
resource "google_compute_instance" "web_server" {
  name         = "${var.environment}-server-atlantis-new"
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
    network    = var.vpc
    subnetwork = var.subnet
    
    access_config {
      # Ephemeral public IP
    }
  }

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = var.startup_script

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}
