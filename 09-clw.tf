resource "aws_cloudwatch_log_group" "log_group_ecs" {
  name              = "${local.cloudwatch_prefix}/ecs"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_group" "application_log" {
  for_each = local.application_logs

  name              = "${local.cloudwatch_prefix}/${each.value}"
  retention_in_days = var.log_retention_in_days
}
