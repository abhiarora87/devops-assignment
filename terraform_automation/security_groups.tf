resource "aws_security_group" "ecs_services" {
  name        = "ecs-service-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow inbound access from the ALB"

  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}