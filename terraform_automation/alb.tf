resource "aws_lb" "main_lb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_services.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_alb_target_group" "my_ecs_target_group" {
  name        = "ecs-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.id
  port              = 5000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.id
    type             = "forward"
  }
}