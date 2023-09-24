output "ecr_repo_url" {
  value = aws_ecr_repository.my_ecr_repository.repository_url
}