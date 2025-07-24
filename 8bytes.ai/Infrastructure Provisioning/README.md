# AWS Infrastructure Provisioning with Terraform

## Overview

This project provisions a complete infrastructure setup on **AWS** using **Terraform**.  
The infrastructure includes:

- **VPC** with public and private subnets
- **EC2 instance** for application hosting (can be extended to ECS/EKS)
- **RDS PostgreSQL** database
- **Application Load Balancer (ALB)** for frontend traffic
- **Security Groups** for controlled access
- **Remote state management** using AWS S3

---

## Architecture

                        +--------------------------+
                        |        Internet           |
                        +------------+-------------+
                                    |
                            +-------+-------+
                            | Application   |
                            | Load Balancer |
                            +-------+-------+
                                    |
                  +------------------+-----------------+
                  |                                    |
            +----------------+              +----------------+
            | Public Subnet |               | Private Subnet |
            | (ALB)         |               | (EC2 + RDS)    |
            +----------------+              +----------------+



---

## Components Provisioned

### 1️⃣ VPC and Networking

- **VPC** (`10.0.0.0/16`)
- **Public Subnet** (`10.0.1.0/24`) for ALB
- **Private Subnet** (`10.0.2.0/24`) for EC2 & RDS
- **Internet Gateway** for internet access
- **Route Tables** for correct routing

### 2️⃣ EC2 Instance

- Launched in **Private Subnet**
- For application backend hosting
- Accepts traffic only from ALB via security groups

### 3️⃣ Application Load Balancer (ALB)

- Public-facing ALB
- Listens on port `80`
- Forwards traffic to EC2 instance in private subnet

### 4️⃣ RDS PostgreSQL

- Managed PostgreSQL database
- Deployed in **Private Subnet**
- Accessed by EC2 instance securely

### 5️⃣ Security Groups

| Security Group | Description                      |
|----------------|----------------------------------|
| **ALB SG**      | Allows HTTP (80) from the internet |
| **EC2 SG**      | Allows HTTP only from ALB        |
| **RDS SG**      | Allows PostgreSQL (5432) from EC2 |

---

## Configuration

All configurations are defined in `variables.tf`.

### Variables

| Name               | Description                   | Default       |
|-------------------|-------------------------------|---------------|
| aws_region         | AWS Region                    | us-east-1     |
| vpc_cidr           | VPC CIDR block                | 10.0.0.0/16   |
| public_subnet_cidr | Public Subnet CIDR block      | 10.0.1.0/24   |
| private_subnet_cidr| Private Subnet CIDR block     | 10.0.2.0/24   |
| instance_type      | EC2 Instance Type             | t3.micro      |
| db_username        | PostgreSQL username           | admin         |
| db_password        | PostgreSQL password (input)   | N/A (prompt)  |
| db_name            | PostgreSQL database name      | appdb         |

---

## Remote State Management

Terraform state is stored remotely using **AWS S3**.

Example backend configuration (`backend.tf`):

```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "aws-infra/terraform.tfstate"
    region = "us-east-1"
  }
}
