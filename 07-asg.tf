#########################
# ECS Autoscaling Group #
#########################

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${local.service_name}-ecs-asg"
  max_size              = local.task_max_capacity
  min_size              = local.task_min_capacity
  vpc_zone_identifier   = local.subnet_ids
  health_check_type     = "ELB"
  protect_from_scale_in = local.protect_from_scale_in_enabled

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }
}
