###############
# Application #
###############

variable "application" {
  type        = string
  description = "The type of the application, supported types: go"
  default     = "go"
}

variable "environment" {
  type        = string
  description = "The environment this service is being run"
}

variable "image_name" {
  type        = string
  description = "The image name of the application that will be deployed"
}

variable "image_version" {
  type        = string
  description = "The image version of the application that will be deployed."
  default     = "latest"
}

variable "service_name" {
  type        = string
  description = "The name of the service."
}

variable "service_port" {
  type        = string
  default     = "8080"
  description = "Port which service will be running"
}

variable "environment_variables" {
  description = "List of environment variables to pass to the task"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

#####################
# Additional Policy #
#####################

variable "cross_account_role_arns" {
  type        = list(string)
  description = "ARNs to assume cross account role"
  default     = []
}

variable "allowed_s3_bucket_arns" {
  type        = list(string)
  description = "List of S3 bucket which service is allowed to get/put."
  default     = []
}

variable "allowed_to_receive_message_sqs_arns" {
  type        = list(string)
  description = "List of SQS ARNs which service is allowed to receive message."
  default     = []
}

variable "allowed_to_send_message_sqs_arns" {
  type        = list(string)
  description = "List of SQS ARNs which service is allowed to send message."
  default     = []
}

variable "allowed_to_use_kms_arns" {
  type        = list(string)
  description = "List of KMS ARNs which service is allowed to use."
  default     = []
}

variable "allowed_to_use_cross_account_kms_arns" {
  type        = list(string)
  description = "List of other account's KMS ARNs which service is allowed to use."
  default     = []
}

variable "allowed_to_publish_sns_topic_arns" {
  type        = list(string)
  description = "List of SNS ARNs which service is allowed to publish topics."
  default     = []
}

variable "allowed_to_access_dynamodb_arns" {
  type        = list(string)
  description = "List of DynamoDB ARNs which service is allowed to use."
  default     = []
}

variable "allowed_lambda_function_url_arns" {
  type        = list(string)
  description = "List of Lambda Function which service is allowed to invoke through FunctionURL."
  default     = []
}
variable "additional_trust_policy_principals" {
  type = list(
    object({
      type        = string
      identifiers = list(string)
    })
  )
  description = <<-EOT
    List of additional principals to be added in the trust policy.
    Format: `{ type = <principal-type>, identifiers = [ <principal>, <principal> ] }`
    Example:
    ```hcl
    [
      {
        type        = "AWS"
        identifiers = ["*"]
      }
    ]
    ```
  EOT
  default     = []
}

###################
# VPC Definitions #
###################

variable "alb_id" {
  type        = string
  description = "The ID of the ALB."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

################
# EC2 Instance #
################

variable "instance_type" {
  type        = string
  description = "The instance type of the EC2 instance."
  default     = "t3.micro"
}

variable "read_only_root_filesystem" {
  type        = bool
  description = "Specifies whether to restrict filesystem access for this service."
  default     = false
}

#########################
# ECS Autoscaling Group #
#########################

variable "task_min_capacity" {
  type        = number
  description = "The minimum number of tasks to run in the autoscaling group."
  default     = 1
}

variable "task_max_capacity" {
  type        = number
  description = "The maximum number of tasks to run in the autoscaling group."
  default     = 2
}

variable "vpc_zone_ids" {
  type        = list(string)
  description = "List of IDs of VPC zones to launch the autoscaling group in."
}

variable "protect_from_scale_in_enabled" {
  type        = bool
  description = "Whether or not to protect the autoscaling group from scale in."
  default     = false
}

###############
# ECS Cluster #
###############

variable "container_insight_enabled" {
  description = "Enable container insights for the cluster."
  type        = bool
  default     = true
}

#########################
# ECS Capacity Provider #
#########################

variable "managed_scaling" {
  description = "Managed scaling configuration for the capacity provider."
  type = object({
    enabled                   = bool
    minimum_scaling_step_size = number
    maximum_scaling_step_size = number
  })
  default = {
    enabled                   = false
    minimum_scaling_step_size = 1
    maximum_scaling_step_size = 1
  }
}

###############
# ECS Service #
###############

variable "task_desired_count" {
  description = "Number of tasks to run in the service."
  type        = string
  default     = 2
}

variable "subnet_ids" {
  description = "List of IDs of subnets to launch the service in."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of IDs of security groups to associate with the service."
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Whether or not to assign public IP address to the task ENI."
  type        = string
  default     = false
}

variable "deployment_circuit_breaker" {
  description = "Deployment circuit breaker configuration."
  type = object({
    enabled  = bool
    rollback = bool
  })
  default = {
    enabled  = true
    rollback = true
  }
}

variable "deployment_controller_type" {
  description = "The deployment controller type to use for the service."
  type        = string
  default     = "ECS"
}

variable "execute_command_enabled" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  type        = bool
  default     = false
}

############
# ECS Task #
############

variable "app_cpu" {
  description = "The number of CPU units used by the task."
  type        = number
  default     = 512
}

variable "app_memory" {
  description = "The amount of memory (in MiB) used by the task."
  type        = number
  default     = 1024
}

###################
# CloudWatch Logs #
###################

variable "log_groups" {
  description = "List of log groups to create."
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "The number of days to retain log events."
  type        = number
  default     = 14
}

##########
# Others #
##########

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags that will be appendend to all resources tags."
  default     = {}
}
