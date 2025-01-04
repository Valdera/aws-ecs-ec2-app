resource "aws_cloudwatch_log_group" "log_group_ecs" {
  name              = "${local.cloudwatch_prefix}/ecs"
  retention_in_days = var.log_retention_in_days

  tags = merge(local.common_tags,
    {
      Name        = "${local.service_name}-ecs-cluster"
      Description = "Log group for ECS cluster ${local.service_name}"
    }
  )
}

resource "aws_cloudwatch_log_group" "log_group_apps" {
  for_each = toset(local.log_groups)

  name              = "${local.cloudwatch_prefix}/${each.value}"
  retention_in_days = var.log_retention_in_days

  tags = merge(local.common_tags,
    {
      Name        = "${local.service_name}-${each.value}"
      Description = "Log group for ${each.value}"
    }
  )
}
