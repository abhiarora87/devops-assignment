resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "python-ecs-cluster"
}

resource "aws_ecs_service" "my_ecs_service" {
  name                               = "python-ecs-service"
  cluster                            = aws_ecs_cluster.my_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.main_task_definition.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = [aws_security_group.ecs_services.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.arn
    container_name   = "python-ecs-cluster"
    container_port   = 5000
  }
}

resource "aws_ecs_task_definition" "main_task_definition" {
  family                   = "my-task-definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "python-ecs-cluster"
      image     = "${var.account_number}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo_name}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])

}