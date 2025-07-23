variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}

variable "db_name" {
  default = "appdb"
}
