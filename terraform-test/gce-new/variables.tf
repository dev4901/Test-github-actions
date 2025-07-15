# variables.tf
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_name" {
  description = "The name of the project for labeling"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "vpc" {
  type = string
}

variable "subnet" {
  type = string
}

variable "service_account" {
  type = string
}

variable "machine_type" {
  description = "The machine type for the GCE instance"
  type        = string
  default     = "e2-small"
}

variable "image_family" {
  description = "The image family for the boot disk"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "disk_size" {
  description = "The size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "The type of the boot disk"
  type        = string
  default     = "pd-standard"
  
  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced"], var.disk_type)
    error_message = "Disk type must be one of: pd-standard, pd-ssd, pd-balanced."
  }
}

variable "startup_script" {
  description = "Startup script to run on instance boot"
  type        = string
#   default     = <<-EOF
#   #!/bin/bash
#   apt-get update
#   apt-get install -y nginx
#   systemctl start nginx
#   systemctl enable nginx
#   echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
# EOF
}
