# prod.tfvars
#project_id   = "cellular-motif-457805-t1"
#project_name = "my-first-project"
#region       = "us-central1"
#zone         = "us-central1-b"
project_id   = "searce-playground-v2"
project_name = "searce-playground-02012024"
region       = "asia-south1"
zone         = "asia-south1-b"
environment  = "prod"

# Instance configuration
machine_type = "e2-micro"
image_family = "debian-cloud/debian-12"
disk_size    = 30
disk_type    = "pd-standard"

# Network configuration
#vpc = "vpc-main"
vpc = "pilot-training-2025-vpc"
subnet = "devansh-subnet"
#service_account = "gce-custom-sa@cellular-motif-457805-t1.iam.gserviceaccount.com"
service_account = "pilot-training-2025-sa@searce-playground-v2.iam.gserviceaccount.com"
# Production startup script
startup_script = <<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx htop curl fail2ban ufw

# Configure firewall
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# Start services
systemctl start nginx
systemctl enable nginx
systemctl start fail2ban
systemctl enable fail2ban

# Create a simple page
echo "<h1>Production Server - Terraform Managed</h1>" > /var/www/html/index.html
echo "<p>Server: $(hostname)</p>" >> /var/www/html/index.html
echo "<p>Deployed: $(date)</p>" >> /var/www/html/index.html
EOF
