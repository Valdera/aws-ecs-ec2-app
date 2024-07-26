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
    ACCOUNTID     = data.aws_caller_identity.current.account_id
    ACCOUNTNAME   = data.aws_iam_account_alias.current.account_alias
    ENVIRONMENT   = var.environment
    CLUSTER       = local.cluster
    SERVICE_NAME  = local.service_name
  }

  ec2_instance_type = var.ec2_instance_type

  cloudwatch_prefix = "/tvlk/${local.cluster_role}-${var.application}/${var.service_name}"

  // ECS Task
  ecs_task_aws_service_name = "ecs-tasks.amazonaws.com"
  ecs_task_definition_name = "${local.service_name}-ecs-task-definition"

}
