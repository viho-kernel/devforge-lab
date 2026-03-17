terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket  = "devforge-lab-dev-backend-bucket"
    key     = "terra-core/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
    profile = "default"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}
