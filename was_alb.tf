resource "aws_lb" "project-was-alb" {
  name               = "project-was-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project-vpc-was-sg.id]
  subnet_mapping {
    subnet_id            = aws_subnet.project-pri-was-1.id
  }

  subnet_mapping {
    subnet_id            = aws_subnet.project-pri-was-2.id
  }
}

resource "aws_lb_target_group" "project-was-alb-tg" {
  name     = "project-was-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.project-vpc.id

    load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 3
    interval            = 10
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.project-was-alb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "was-alb-listener" {
  load_balancer_arn = aws_lb.project-was-alb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project-was-alb-tg.arn
  }
}