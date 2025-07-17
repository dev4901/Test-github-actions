# prod.tfvars
project_id   = "cellular-motif-457805-t1"
project_name = "my-first-project"
region       = "us-central1"
zone         = "us-central1-b"
environment  = "gqa"

# Instance configuration
machine_type = "e2-micro"
image_family = "ubuntu-2204-lts"
disk_size    = 50
disk_type    = "pd-standard"

# Network configuration
vpc             = "vpc-main"
subnet          = "subnet-iowa"
service_account = "gce-custom-sa@cellular-motif-457805-t1.iam.gserviceaccount.com"
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
