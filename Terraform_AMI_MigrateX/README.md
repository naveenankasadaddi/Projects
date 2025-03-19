# AMI Migration Using Terraform

## Problem Statement

Managing Amazon Machine Image (AMI) upgrades can be complex and time-consuming when done manually using the AWS Management Console. The process often involves:

* **Manual Snapshot Management:** Taking snapshots of EBS volumes before migration for data safety.
* **Instance Management:** Launching new instances with the latest AMI.
* **Volume Reattachment:** Detaching and reattaching EBS volumes without data loss.
* **Downtime Risks:** Interruptions during instance replacements.
* **Lack of Visibility:** No version control over configurations.

These challenges lead to increased human errors, operational delays, and the risk of downtime.

## Solution Using Terraform

To address these challenges, a fully automated AMI migration solution was developed using Terraform. The following `main.tf` file demonstrates the key components of the solution:

```terraform
#please mention your required provider
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  profile = "<profile-name>"
  region  = "<region>"
}

data "aws_ami" "latest_amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

output "latest_amazon_linux_2023" {
  value       = data.aws_ami.latest_amazon_linux_2023.id
  sensitive   = false
  description = "This is the latest al2023 image"
  depends_on  = []
}

resource "aws_ebs_snapshot" "gbd_lcp_09_snapshot" {
  volume_id = "<volume-id-of-existing-volume>"

  tags = {
    Name = "<description>"
  }
  timeouts {
    create = "60m"
  }
}

output "snapshot_id" {
  value       = aws_ebs_snapshot.gbd_lcp_09_snapshot.id
  sensitive   = false
  description = "This is the id of the snapshot $"
}

resource "aws_instance" "<name>-newal2023" {
  ami                         = data.aws_ami.latest_amazon_linux_2023.id
  instance_type               = "<machine-type>"
  key_name                    = "<key>"
  subnet_id                   = "<subnet-id>"
  associate_public_ip_address = false
  availability_zone           = "<region>"
  monitoring                  = false
  ebs_optimized               = true
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    tags = {
      Name = "<name>-newal2023"
    }
  }
  ebs_block_device {
    delete_on_termination = false
    volume_size           = 150
    volume_type           = "standard"
    device_name           = "/dev/sdf"
    snapshot_id           = aws_ebs_snapshot.gbd_lcp_09_snapshot.id
    tags = {
      Name = "<name>-newal2023"
    }
  }

  vpc_security_group_ids = [
    "<sg-id>",
  ]

  tags = {
    Name        = "<name>-newal2023"
    Project     = "<name>"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Region      = "region"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }
}

```
# AMI Migration Using Terraform

## Advantages

* **Automated and Efficient:** Eliminates manual interventions, saving time and reducing errors.
* **Data Protection:** Automated snapshots ensure data safety during migrations.
* **Cost Management:** Efficient resource utilization and accurate instance provisioning.
* **Version Control:** Terraform ensures infrastructure changes are tracked and managed.

## Getting Started

To use this Terraform-based AMI migration solution, follow these steps:

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd ami-migration-terraform
    ```

2.  **Configure your AWS credentials** using AWS CLI or environment variables, and replace the placeholders in the `main.tf` file.

3.  **Initialize and apply the Terraform configuration:**

    ```bash
    terraform init
    terraform apply
    ```

4.  **Monitor the migration** using the Terraform logs and AWS Console.

## Conclusion

This Terraform-based AMI migration solution provides a robust and scalable approach to managing AMI upgrades. It ensures seamless transitions to the latest AMIs while maintaining data integrity.