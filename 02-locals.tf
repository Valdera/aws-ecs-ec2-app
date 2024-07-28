locals {
  cluster_role = "app"
  cluster               = format("%s-%s", local.service_name, local.cluster_role)
  service_name = var.service_name
  service_port = var.service_port
  environment           = var.environment
  short_environment     = var.environment == "staging" ? "stg" : "prod"

  read_only_root_filesystem = var.read_only_root_filesystem

  image_name = var.image_name
  image_version    = var.image_version
  docker_labels = {
    ACCOUNT_ID     = data.aws_caller_identity.current.account_id
    ACCOUNT_NAME   = data.aws_iam_account_alias.current.account_alias
    ENVIRONMENT   = var.environment
    CLUSTER       = local.cluster
    SERVICE_NAME  = local.service_name
  }




  // EC2 Instance
  instance_type = var.instance_type

  // ECS Autoscaling Group
  task_min_capacity = var.task_min_capacity
  task_max_capacity = var.task_max_capacity
  vpc_zone_ids = var.vpc_zone_ids
  protect_from_scale_in_enabled = var.protect_from_scale_in_enabled

  // ECS Capacity Provider
  managed_scaling = var.managed_scaling

  // ECS Service
  task_desired_count = var.task_desired_count
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  assign_public_ip = var.assign_public_ip
  deployment_circuit_breaker = var.deployment_circuit_breaker
  deployment_controller_type = var.deployment_controller_type
  execute_command_enabled = var.execute_command_enabled
  container_insight_enabled = var.container_insight_enabled

  // ECS Task
  app_cpu = var.app_cpu
  app_memory = var.app_memory

  // CloudWatch Logs
  log_retention_in_days = var.log_retention_in_days
}
