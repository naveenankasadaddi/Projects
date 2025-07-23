terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "aws-infra/terraform.tfstate"
    region = "<region>"
  }
}
