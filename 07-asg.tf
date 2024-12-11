#########################
# ECS Autoscaling Group #
#########################

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${local.service_name}-ecs-asg"
  max_size              = local.task_max_capacity
  min_size              = local.task_min_capacity
  vpc_zone_identifier   = local.vpc_zone_ids
  health_check_type     = local.alb_sg_ids != [] ? "ELB" : "EC2"
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

  tags = merge(local.common_tags, {
    Name        = "${local.service_name}-ecs-asg"
    Description = "Autoscaling group for ${local.service_name} EC2 instances"
  })
}
