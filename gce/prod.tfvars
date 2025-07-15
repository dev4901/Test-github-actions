# prod.tfvars
project_id   = "your-gcp-project-id"
project_name = "my-terraform-project"
region       = "us-west1"
zone         = "us-west1-a"
environment  = "prod"

# Instance configuration
machine_type = "e2-standard-2"
image_family = "ubuntu-2204-lts"
disk_size    = 50
disk_type    = "pd-ssd"

# Network configuration
subnet_cidr = "10.1.0.0/24"
allowed_cidr_blocks = [
  "203.0.113.0/24",  # Your office IP range
  "198.51.100.0/24"  # Your home IP range
]

# SSH configuration
ssh_user             = "ubuntu"
ssh_public_key_path  = "~/.ssh/id_rsa.pub"

# Static IP for production
create_static_ip = true

# Production startup script
startup_script = <<-EOF
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