resource "aws_autoscaling_group" "project-asg" {
  name = "project-asg"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_grace_period = 40
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier = [aws_subnet.project-pri-was-1.id, aws_subnet.project-pri-was-2.id]
  launch_template {
    id      = aws_launch_template.project-was-tem.id
  }
}

resource "aws_autoscaling_attachment" "project_asg-attachment" {
  autoscaling_group_name = "project-asg"
  lb_target_group_arn    = aws_lb_target_group.project-was-alb-tg.arn
}

resource "aws_autoscaling_policy" "project-asg-policy" {
  autoscaling_group_name = "project-asg"
  name                   = "project-asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
    disable_scale_in = true
  }
}