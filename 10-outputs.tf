output "ecs_cluster_id" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "The ID of the ECS cluster"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.ecs_cluster.arn
  description = "The ARN of the ECS cluster"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.ecs_cluster.name
  description = "The name of the ECS cluster"
}

output "ecs_service_id" {
  value       = aws_ecs_service.ecs_service.id
  description = "The ID of the ECS service"
}

output "execution_role_id" {
  value       = aws_iam_role.ecs_execution_role.id
  description = "The ID of the ECS task execution role"
}

output "ami_id" {
  value       = data.aws_ami.amazon_linux_2.id
  description = "The ID of the AMI"
}

output "sg_ec2_id" {
  value       = aws_security_group.ec2.id
  description = "The ID of the EC2 security group"
}

output "sg_ec2_arn" {
  value       = aws_security_group.ec2.arn
  description = "The ARN of the EC2 security group"
}

output "asg_id" {
  value       = aws_autoscaling_group.ecs_autoscaling_group.id
  description = "The ID of the ECS autoscaling group"
}

output "asg_arn" {
  value       = aws_autoscaling_group.ecs_autoscaling_group.arn
  description = "The ARN of the ECS autoscaling group"
}

output "launch_template_id" {
  value       = aws_launch_template.ecs_launch_template.id
  description = "The ID of the EC2 launch template"
}

output "execution_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "The ARN of the ECS task execution role"
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.ecs_task_definition.arn
  description = "The ARN of the ECS task definition"
}

output "ecs_task_sg_id" {
  value       = aws_security_group.ecs_task.id
  description = "The security group ID for the ECS task"
}

output "ecs_service_name" {
  value       = aws_ecs_service.ecs_service.name
  description = "The name of the ECS service"
}

output "ecs_capacity_provider_id" {
  value       = aws_ecs_capacity_provider.ecs_capacity_provider.id
  description = "The ID of the ECS capacity provider"
}

output "ecs_capacity_provider_arn" {
  value       = aws_ecs_capacity_provider.ecs_capacity_provider.arn
  description = "The ARN of the ECS capacity provider"
}

output "ecs_capacity_provider_name" {
  value       = aws_ecs_capacity_provider.ecs_capacity_provider.name
  description = "The name of the ECS capacity provider"
}
