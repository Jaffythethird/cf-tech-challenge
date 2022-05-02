terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
  shared_config_files = var.shared_config_files
  shared_credentials_files = var.shared_credentials_files
}