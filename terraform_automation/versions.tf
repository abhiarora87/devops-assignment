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
  access_key = "AKIAWJ5CY7JODST2XM6B"
  secret_key = "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"
}


# In production would authenciate using the assumed roles