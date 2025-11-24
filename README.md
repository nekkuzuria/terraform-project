# Terraform AWS Web Server Project

This Terraform project provisions an AWS EC2 instance with a web server that serves a custom HTML page.

## 📋 Overview

This project creates:
- An AWS EC2 instance (t3.micro) running Amazon Linux
- A security group allowing HTTP (port 80) and SSH (port 22) access
- An Apache web server (httpd) configured to serve a custom HTML page
- An SSH key pair for secure instance access

## 🛠️ Prerequisites

Before running this project, ensure you have:

1. **Terraform** installed (version >= 1.5.0)
   ```bash
   terraform --version
   ```

2. **AWS CLI** configured with valid credentials
   ```bash
   aws configure
   ```

3. **SSH Key Pair** generated at `~/.ssh/terraform_key.pub`
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform_key
   ```

4. **AWS Account** with appropriate permissions to create EC2 instances, security groups, and key pairs

## 📁 Project Structure

```
.
├── main.tf              # Main infrastructure configuration
├── terraform.tf         # Provider and version requirements
├── hello.html           # Custom HTML page served by the web server
├── terraform.tfstate    # Terraform state file (auto-generated)
└── README.md           # This file
```

## 🚀 Usage

### 1. Initialize Terraform

Initialize the Terraform working directory and download required providers:

```bash
terraform init
```

### 2. Review the Plan

Preview the resources that will be created:

```bash
terraform plan
```

### 3. Apply the Configuration

Create the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### 4. Access Your Web Server

After successful deployment, Terraform will output the instance details. You can find the public IP in the AWS Console or by running:

```bash
terraform show | grep public_ip
```

Visit `http://<public-ip>` in your browser to see your web page.

### 5. SSH Access

Connect to your instance via SSH:

```bash
ssh -i ~/.ssh/terraform_key ec2-user@<public-ip>
```

## 🌍 Configuration Details

### Region
- **AWS Region**: `ap-southeast-3` (Jakarta)
- To change the region, edit the `region` value in `terraform.tf`

### AMI
- **AMI ID**: `ami-0559665adb3f0e333`
- This is an Amazon Linux AMI for the ap-southeast-3 region

### Instance Type
- **Type**: `t3.micro` (1 vCPU, 1 GB RAM)
- Free tier eligible

### Security Group Rules
- **Inbound**:
  - Port 80 (HTTP) from anywhere (0.0.0.0/0)
  - Port 22 (SSH) from anywhere (0.0.0.0/0)
- **Outbound**:
  - All traffic allowed

⚠️ **Security Note**: The security group allows SSH and HTTP from anywhere. For production use, restrict SSH access to your IP address.

## 🧹 Cleanup

To destroy all resources created by this project:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

## 📝 Files Description

### main.tf
Contains the main infrastructure resources:
- `aws_security_group.web_sg` - Security group configuration
- `aws_key_pair.terraform_key` - SSH key pair
- `aws_instance.web` - EC2 instance with user data script

### terraform.tf
Defines:
- Required Terraform version (>= 1.5.0)
- AWS provider configuration (version ~> 5.0)
- AWS region setting

### hello.html
Custom HTML page that gets deployed to the web server at `/var/www/html/index.html`

## 🔧 Troubleshooting

### Issue: "No valid credential sources found"
- Ensure AWS CLI is configured: `aws configure`
- Check that your AWS credentials are valid

### Issue: "Error launching source instance: InvalidKeyPair.NotFound"
- Verify that the SSH key exists at `~/.ssh/terraform_key.pub`
- Ensure the key has proper permissions

### Issue: Cannot access web page
- Wait 2-3 minutes after deployment for user data script to complete
- Check security group rules allow HTTP traffic
- Verify instance is in "running" state in AWS Console

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform Documentation](https://www.terraform.io/docs)

## 📄 License

This project is provided as-is for educational and demonstration purposes.

