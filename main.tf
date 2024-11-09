# Specify the Terraform version and AWS provider requirements
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}
