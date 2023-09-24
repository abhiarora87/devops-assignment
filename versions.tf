terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.18.0"
    }
  }
  required_version = ">= 0.14" # any versions equal or greater than 0.14
}

# Provider Block
provider "aws" {
  region     = var.region
  profile    = "devops-user"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

# In production would authenticate using the assumed roles
