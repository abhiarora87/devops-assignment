variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region hosting the infrastructure"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  type        = list(string)
  description = "Availability zones for VPC"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets inside the VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets inside the VPC"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "account_number" {
  type        = string
  description = "AWS account number"
  default     = "433596201564"
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR Repository Name"
  default     = "pythonapi"
}