###############
# ECS Service #
###############

resource "aws_ecs_service" "service" {
  name                               = "${var.namespace}_ECS_Service_${var.environment}"
  iam_role                           = aws_iam_role.ecs.arn
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = local.ecs_task_desired_count
  deployment_minimum_healthy_percent = local.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = local.ecs_task_deployment_maximum_percent

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker.enable
    rollback = var.deployment_circuit_breaker.rollback
  }

  deployment_controller {
    type = var.deployment_controller.type
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service_target_group.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  ## Spread tasks evenly accross all Availability Zones for High Availability
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ## Make use of all available space on the Container Instances
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  ## Do not update desired count again to avoid a reset to this number on every deployment
  lifecycle {
    ignore_changes = [
      desired_count,
      launch_type
    ]
  }
}

########################
# ECS Task Definitions #
########################

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = local.ecs_task_definition_name
  task_role_arn         = var.task_role_arn

  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  tags = {
    Name        = loval.ecs_task_definition_name
    Environment = var.environment

  }

  lifecycle {
    create_before_destroy = true
  }

  container_definitions = templatefile("${path.module}/templates/container-definition.json.tpl", {
  aws_region     = data.aws_region.current.name
  container_name = local.cluster
  image_name     = local.image_name
  version        = local.image_version
  port           = local.service_port
  log_group      = aws_cloudwatch_log_group.log_group.name
  environment    = jsonencode(var.environment_variables)
    docker_labels             = jsonencode(local.docker_labels)
    read_only_root_filesystem = local.read_only_root_filesystem

  })


dynamic "volume" {
    for_each = var.volumes
    content {

      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
        }
      }
    }
  }
}
