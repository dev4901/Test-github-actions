# GCP Terraform Configuration

This Terraform configuration creates a complete GCP infrastructure setup with a GCE instance, VPC, subnet, firewall rules, and service account.

## Files Structure

```
.
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output definitions
├── dev.tfvars       # Development environment variables
├── prod.tfvars      # Production environment variables
└── README.md        # This file
```

## Prerequisites

1. **GCP Project**: Create a GCP project and enable the Compute Engine API
2. **Authentication**: Set up GCP authentication using one of these methods:
   - Service account key file
   - gcloud CLI authentication
   - Application Default Credentials

3. **Terraform**: Install Terraform (version >= 1.0)

## Setup Instructions

### 1. Authentication Setup

**Option A: Using gcloud CLI**
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
gcloud auth application-default login
```

**Option B: Using Service Account Key**
```bash
export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account-key.json"
```

### 2. Update Variables

Edit the `.tfvars` files to match your requirements:
- Update `project_id` with your actual GCP project ID
- Modify other variables as needed

### 3. SSH Key Setup

## Usage

### Initialize Terraform
```bash
terraform init
```

### Plan Deployment
```bash
# For development
terraform plan -var-file="dev.tfvars"

# For production
terraform plan -var-file="prod.tfvars"
```

### Apply Configuration
```bash
# For development
terraform apply -var-file="dev.tfvars"

# For production
terraform apply -var-file="prod.tfvars"
```

### Destroy Resources
```bash
# For development
terraform destroy -var-file="dev.tfvars"

# For production
terraform destroy -var-file="prod.tfvars"
```

## What Gets Created

1. **VPC Network**: A custom VPC network
2. **Subnet**: A subnet within the VPC
3. **Firewall Rules**: Allow SSH (22), HTTP (80), and HTTPS (443)
4. **Service Account**: For the GCE instance
5. **GCE Instance**: The main compute instance
6. **Static IP** (optional): Based on `create_static_ip` variable

## Accessing the Instance

After deployment, you can SSH into the instance using:
```bash
ssh ubuntu@<EXTERNAL_IP>
```

The external IP will be shown in the Terraform outputs.

## Customization

### Machine Types
Common machine types:
- `e2-micro`: 1 vCPU, 1 GB RAM (always free tier eligible)
- `e2-small`: 1 vCPU, 2 GB RAM
- `e2-medium`: 1 vCPU, 4 GB RAM
- `e2-standard-2`: 2 vCPU, 8 GB RAM
- `e2-standard-4`: 4 vCPU, 16 GB RAM

### Disk Types
- `pd-standard`: Standard persistent disk (cheapest)
- `pd-balanced`: Balanced persistent disk (good performance/cost)
- `pd-ssd`: SSD persistent disk (best performance)

### Images
Common image families:
- `ubuntu-2204-lts`: Ubuntu 22.04 LTS
- `ubuntu-2004-lts`: Ubuntu 20.04 LTS
- `debian-11`: Debian 11
- `centos-stream-9`: CentOS Stream 9

## Security Notes

1. **SSH Keys**: Always use SSH keys instead of passwords
2. **Firewall Rules**: Restrict source IP ranges in production
3. **Service Account**: Use least privilege principle
4. **Updates**: Keep the OS and packages updated
5. **Monitoring**: Set up logging and monitoring

## Troubleshooting

### Common Issues

1. **Authentication Error**: Make sure you're authenticated to GCP
2. **API Not Enabled**: Enable the Compute Engine API in your project
3. **Permission Denied**: Check IAM permissions for your account/service account
4. **SSH Connection**: Verify firewall rules and SSH key configuration

### Useful Commands

```bash
# Check Terraform state
terraform show

# List resources
terraform state list

# Get specific resource info
terraform state show google_compute_instance.web_server

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate
```

## Cost Optimization

1. **Use preemptible instances** for dev/test environments
2. **Right-size instances** based on actual usage
3. **Use standard disks** for non-performance-critical workloads
4. **Delete unused resources** regularly
5. **Set up billing alerts** to monitor costs

## Next Steps

1. **Add monitoring**: Integrate with Google Cloud Monitoring
2. **Load balancing**: Add load balancer for high availability
3. **Auto-scaling**: Implement instance groups and auto-scaling
4. **CI/CD**: Integrate with your CI/CD pipeline
5. **Backup**: Set up automated backups for persistent disks