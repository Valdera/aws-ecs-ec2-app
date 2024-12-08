# ECS EC2 Application Stack Module

> Module to create an ECS EC2 Application Stack

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.30.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.30.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.log_group_apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.log_group_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.ecs_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.ecs_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.ec2_instance_role_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.allow_assume_cross_account_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_dynamodb_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_s3_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_sns_publish_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_sqs_receive_message_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_sqs_send_message_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.allow_use_cross_account_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.execute_command_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.execution_role_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.execution_role_cloudwatch_log_appender](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.execution_role_parameter_store_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_role_cloudwatch_log_appender](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_role_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_role_parameter_store_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ec2_instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.ecs_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_alb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb_target_group) | data source |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_iam_policy_document.allow_assume_cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_cross_account_kms_use](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_dynamodb_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_kms_use](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_lambda_function_url_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_sns_publish](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_sqs_receive_message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_sqs_send_message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_log_appender](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.execute_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.execution_role_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.parameter_store_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags that will be appendend to all resources tags. | `map(string)` | `{}` | no |
| <a name="input_additional_trust_policy_principals"></a> [additional\_trust\_policy\_principals](#input\_additional\_trust\_policy\_principals) | List of additional principals to be added in the trust policy.<br/>Format: `{ type = <principal-type>, identifiers = [ <principal>, <principal> ] }`<br/>Example:<pre>hcl<br/>[<br/>  {<br/>    type        = "AWS"<br/>    identifiers = ["*"]<br/>  }<br/>]</pre> | <pre>list(<br/>    object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_alb_sg_ids"></a> [alb\_sg\_ids](#input\_alb\_sg\_ids) | List of IDs of security groups to associate with the ALB. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_access_dynamodb_arns"></a> [allowed\_to\_access\_dynamodb\_arns](#input\_allowed\_to\_access\_dynamodb\_arns) | List of DynamoDB ARNs which service is allowed to use. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_access_s3_bucket_arns"></a> [allowed\_to\_access\_s3\_bucket\_arns](#input\_allowed\_to\_access\_s3\_bucket\_arns) | List of S3 bucket which service is allowed to get/put. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_assume_cross_account_role_arns"></a> [allowed\_to\_assume\_cross\_account\_role\_arns](#input\_allowed\_to\_assume\_cross\_account\_role\_arns) | List of cross account role ARNs which service is allowed to assume. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_invoke_lambda_function_url_arns"></a> [allowed\_to\_invoke\_lambda\_function\_url\_arns](#input\_allowed\_to\_invoke\_lambda\_function\_url\_arns) | List of Lambda Function which service is allowed to invoke through FunctionURL. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_publish_sns_topic_arns"></a> [allowed\_to\_publish\_sns\_topic\_arns](#input\_allowed\_to\_publish\_sns\_topic\_arns) | List of SNS ARNs which service is allowed to publish topics. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_receive_message_sqs_arns"></a> [allowed\_to\_receive\_message\_sqs\_arns](#input\_allowed\_to\_receive\_message\_sqs\_arns) | List of SQS ARNs which service is allowed to receive message. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_send_message_sqs_arns"></a> [allowed\_to\_send\_message\_sqs\_arns](#input\_allowed\_to\_send\_message\_sqs\_arns) | List of SQS ARNs which service is allowed to send message. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_use_cross_account_kms_arns"></a> [allowed\_to\_use\_cross\_account\_kms\_arns](#input\_allowed\_to\_use\_cross\_account\_kms\_arns) | List of other account's KMS ARNs which service is allowed to use. | `list(string)` | `[]` | no |
| <a name="input_allowed_to_use_kms_arns"></a> [allowed\_to\_use\_kms\_arns](#input\_allowed\_to\_use\_kms\_arns) | List of KMS ARNs which service is allowed to use. | `list(string)` | `[]` | no |
| <a name="input_app_cpu"></a> [app\_cpu](#input\_app\_cpu) | The number of CPU units used by the task. | `number` | `512` | no |
| <a name="input_app_memory"></a> [app\_memory](#input\_app\_memory) | The amount of memory (in MiB) used by the task. | `number` | `1024` | no |
| <a name="input_application"></a> [application](#input\_application) | The type of the application, supported types: go | `string` | `"go"` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether or not to assign public IP address to the task ENI. | `string` | `false` | no |
| <a name="input_bastion_sg_ids"></a> [bastion\_sg\_ids](#input\_bastion\_sg\_ids) | List of IDs of security groups to associate with the bastion host. | `list(string)` | `[]` | no |
| <a name="input_container_insight_enabled"></a> [container\_insight\_enabled](#input\_container\_insight\_enabled) | Enable container insights for the cluster. | `bool` | `true` | no |
| <a name="input_deployment_circuit_breaker"></a> [deployment\_circuit\_breaker](#input\_deployment\_circuit\_breaker) | Deployment circuit breaker configuration. | <pre>object({<br/>    enabled  = bool<br/>    rollback = bool<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "rollback": true<br/>}</pre> | no |
| <a name="input_deployment_controller_type"></a> [deployment\_controller\_type](#input\_deployment\_controller\_type) | The deployment controller type to use for the service. | `string` | `"ECS"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment this service is being run | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | List of environment variables to pass to the task | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_execute_command_enabled"></a> [execute\_command\_enabled](#input\_execute\_command\_enabled) | Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `bool` | `false` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The image name of the application that will be deployed | `string` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The image version of the application that will be deployed. | `string` | `"latest"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the EC2 instance. | `string` | `"t3.micro"` | no |
| <a name="input_log_groups"></a> [log\_groups](#input\_log\_groups) | List of log groups to create. | `list(string)` | `[]` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The number of days to retain log events. | `number` | `14` | no |
| <a name="input_managed_scaling"></a> [managed\_scaling](#input\_managed\_scaling) | Managed scaling configuration for the capacity provider. | <pre>object({<br/>    enabled                   = bool<br/>    minimum_scaling_step_size = number<br/>    maximum_scaling_step_size = number<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "maximum_scaling_step_size": 1,<br/>  "minimum_scaling_step_size": 1<br/>}</pre> | no |
| <a name="input_protect_from_scale_in_enabled"></a> [protect\_from\_scale\_in\_enabled](#input\_protect\_from\_scale\_in\_enabled) | Whether or not to protect the autoscaling group from scale in. | `bool` | `false` | no |
| <a name="input_read_only_root_filesystem"></a> [read\_only\_root\_filesystem](#input\_read\_only\_root\_filesystem) | Specifies whether to restrict filesystem access for this service. | `bool` | `false` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of IDs of security groups to associate with the service. | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service. | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Port which service will be running | `string` | `"8080"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of IDs of subnets to launch the service in. | `list(string)` | n/a | yes |
| <a name="input_task_desired_count"></a> [task\_desired\_count](#input\_task\_desired\_count) | Number of tasks to run in the service. | `string` | `2` | no |
| <a name="input_task_max_capacity"></a> [task\_max\_capacity](#input\_task\_max\_capacity) | The maximum number of tasks to run in the autoscaling group. | `number` | `2` | no |
| <a name="input_task_min_capacity"></a> [task\_min\_capacity](#input\_task\_min\_capacity) | The minimum number of tasks to run in the autoscaling group. | `number` | `1` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC. | `string` | n/a | yes |
| <a name="input_vpc_zone_ids"></a> [vpc\_zone\_ids](#input\_vpc\_zone\_ids) | List of IDs of VPC zones to launch the autoscaling group in. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Configurations

### ECS

#### Terminology and Components

> Full
> Explanation: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)

There are three layers in Amazon ECS:

- **Capacity** - The infrastructure where your containers run
- **Controller** - Deploy and manage your applications that run on the containers
- **Provisioning** - The tools that you can use to interface with the scheduler to deploy and manage
  your applications and containers

#### ECS Service

`deployment_ciruit_breaker`

- The **deployment circuit breaker** determines whether a service deployment will fail if the
  service can't reach a steady state. If it is turned on, a service deployment will transition to a
  failed state and stop launching new tasks.
-
Reference: [AWS Docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-service-deploymentcircuitbreaker.html)

`deployment_controller`

- The deployment controller type to use
    - `ECS`

      The rolling update deployment type involves replacing the current running version of the
      container with the latest version. The number of containers Amazon ECS adds or removes from
      the service during a rolling update is controlled by adjusting the minimum and maximum number
      of healthy tasks allowed during a service deployment.

    - `CODE_DEPLOY`

      The blue/green deployment type uses the blue/green deployment model powered by AWS CodeDeploy,
      which allows you to verify a new deployment of a service before sending production traffic to
      it.

    - `EXTERNAL`

      The external (EXTERNAL) deployment type enables you to use any third-party deployment
      controller for full control over the deployment process for an Amazon ECS service.

-
Reference: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_DeploymentController.html)

`ordered_placement_strategy`

- For tasks that use the EC2 launch type, Amazon ECS must determine where to place the task based on
  the requirements specified in the task definition, such as CPU and memory. Similarly, when you
  scale down the task count, Amazon ECS must determine which tasks to terminate.
-
Reference: [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html)

## External Reference

