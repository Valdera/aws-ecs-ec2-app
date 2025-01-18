###############
# ECS Cluster #
###############

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.service_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = local.container_insight_enabled ? "enabled" : "disabled"
  }

  tags = merge(local.common_tags, {
    Name        = "${local.service_name}-ecs-cluster"
    Description = "ECS cluster for ${local.service_name}"
  })
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${local.service_name}-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_termination_protection = local.managed_scaling.enabled ? "ENABLED" : "DISABLED"

    managed_scaling {
      minimum_scaling_step_size = local.managed_scaling.minimum_scaling_step_size
      maximum_scaling_step_size = local.managed_scaling.maximum_scaling_step_size
      status                    = local.managed_scaling.enabled ? "ENABLED" : "DISABLED"
    }
  }

  tags = merge(local.common_tags, {
    Name        = "${local.service_name}-ecs-capacity-provider"
    Description = "Capacity provider for ${local.service_name} ECS cluster"
  })
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
}

###############
# ECS Service #
###############

resource "aws_ecs_service" "ecs_service" {
  name                   = "${local.service_name}-ecs-service"
  cluster                = aws_ecs_cluster.ecs_cluster.id
  task_definition        = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count          = local.task_desired_count
  enable_execute_command = local.execute_command_enabled

  propagate_tags          = "TASK_DEFINITION"
  enable_ecs_managed_tags = true

  deployment_circuit_breaker {
    enable   = local.deployment_circuit_breaker.enabled
    rollback = local.deployment_circuit_breaker.rollback
  }

  deployment_controller {
    type = local.deployment_controller_type
  }

  load_balancer {
    target_group_arn = local.alb_target_group_arn
    container_name   = local.container_name
    container_port   = local.service_port
  }

  network_configuration {
    subnets          = local.subnet_ids
    security_groups  = concat(local.security_group_ids, [aws_security_group.ecs_task.id])
    assign_public_ip = local.assign_public_ip
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      launch_type,
      load_balancer,
      network_configuration
    ]
  }

  tags = merge(local.common_tags, {
    Name        = "${local.service_name}-ecs-service"
    Description = "ECS service for ${local.service_name}"
  })
}

######################
# ECS Security Group #
######################

resource "aws_security_group" "ecs_task" {
  name        = "${local.service_name}-ecs-task-sg"
  description = "Security group for EC2 instances in ECS cluster"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [local.alb_security_group_id, aws_security_group.ec2.id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags,
    {
      Name        = "${local.service_name}-ecs-task-sg"
      Description = "Security group for ECS task in ECS cluster"
    }
  )
}


########################
# ECS Task Definitions #
########################

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${local.service_name}-ecs-task-definition"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  network_mode = "awsvpc"

  container_definitions = templatefile("${path.module}/templates/container-definition.json.tpl", {
    app_cpu                   = local.app_cpu
    app_memory                = local.app_memory
    aws_region                = data.aws_region.current.name
    container_name            = local.container_name
    image_uri                 = local.image_uri
    version                   = local.image_version
    port                      = local.service_port
    log_group                 = aws_cloudwatch_log_group.log_group_ecs.name
    environment               = jsonencode(var.environment_variables)
    docker_labels             = jsonencode(local.docker_labels)
    read_only_root_filesystem = local.read_only_root_filesystem
    health_check_path         = local.health_check_path
  })

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name        = "${local.service_name}-ecs-task-definition"
    Description = "ECS task definition for ${local.service_name}"
  })
}

