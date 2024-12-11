locals {
  // Application definitions
  application = var.application

  service_name          = var.service_name
  service_port          = var.service_port
  environment_variables = var.environment_variables

  environment       = var.environment
  short_environment = var.environment == "staging" ? "stg" : "prod"

  // Policy
  allowed_to_assume_cross_account_role_arns  = var.allowed_to_assume_cross_account_role_arns
  allowed_to_access_s3_bucket_arns           = var.allowed_to_access_s3_bucket_arns
  allowed_to_receive_message_sqs_arns        = var.allowed_to_receive_message_sqs_arns
  allowed_to_send_message_sqs_arns           = var.allowed_to_send_message_sqs_arns
  allowed_to_use_cross_account_kms_arns      = var.allowed_to_use_cross_account_kms_arns
  allowed_to_publish_sns_topic_arns          = var.allowed_to_publish_sns_topic_arns
  allowed_to_access_dynamodb_arns            = var.allowed_to_access_dynamodb_arns
  allowed_to_invoke_lambda_function_url_arns = var.allowed_to_invoke_lambda_function_url_arns
  allowed_to_use_kms_arns                    = var.allowed_to_use_kms_arns
  additional_trust_policy_principals         = var.additional_trust_policy_principals

  // Image definitions
  image_uri     = var.image_uri
  image_version = var.image_version
  docker_labels = {
    ACCOUNT_ID   = data.aws_caller_identity.current.account_id
    ACCOUNT_NAME = data.aws_iam_account_alias.current.account_alias
    ENVIRONMENT  = var.environment
    CLUSTER      = "${local.service_name}-app"
    SERVICE_NAME = local.service_name
  }

  // VPC
  vpc_id                    = var.vpc_id
  alb_target_group_arn      = var.alb_target_group_arn
  alb_security_group_id     = var.alb_security_group_id
  bastion_security_group_id = var.bastion_security_group_id

  // EC2 Instance
  instance_type             = var.instance_type
  read_only_root_filesystem = var.read_only_root_filesystem
  user_data_path            = var.user_data_path

  // ECS Autoscaling Group
  task_min_capacity             = var.task_min_capacity
  task_max_capacity             = var.task_max_capacity
  protect_from_scale_in_enabled = var.protect_from_scale_in_enabled

  // ECS Cluster
  container_insight_enabled = var.container_insight_enabled

  // ECS Capacity Provider
  managed_scaling = var.managed_scaling

  // ECS Service
  task_desired_count         = var.task_desired_count
  subnet_ids                 = var.subnet_ids
  security_group_ids         = var.security_group_ids
  assign_public_ip           = var.assign_public_ip
  deployment_circuit_breaker = var.deployment_circuit_breaker
  deployment_controller_type = var.deployment_controller_type
  execute_command_enabled    = var.execute_command_enabled

  // ECS Task
  app_cpu    = var.app_cpu
  app_memory = var.app_memory

  // CloudWatch Logs
  log_groups            = var.log_groups
  log_retention_in_days = var.log_retention_in_days
  cloudwatch_prefix     = "/app-${local.application}/${local.service_name}"

  // Others
  common_tags = merge(var.additional_tags, {
    Environment = local.environment
    ManagedBy   = "Terraform"
  })
}
