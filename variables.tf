variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region hosting the infrastructure"
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