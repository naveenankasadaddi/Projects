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
  #Please specify you required configuration
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    tags = {
      Name = "<name>-newal2023"
    }
  }
  #Please specify you required configuration
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
