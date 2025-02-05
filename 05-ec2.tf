data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${local.service_name}-ec2-launch-template"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = local.instance_type
  user_data              = base64encode("#!/bin/bash\necho \"ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name}\" >> /etc/ecs/ecs.config\n")
  vpc_security_group_ids = [aws_security_group.ec2.id]
  update_default_version = true

  key_name = local.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_role_profile.arn
  }

  monitoring {
    enabled = true
  }

  tags = merge(local.common_tags,
    {
      Name        = "${local.service_name}-ec2-launch-template"
      Description = "Launch template for EC2 instances in ECS cluster"
    }
  )
}

######################
# EC2 Security Group #
######################

resource "aws_security_group" "ec2" {
  name        = "${local.service_name}-ec2-sg"
  description = "Security group for EC2 instances in ECS cluster"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [local.alb_security_group_id]
  }

  ingress {
    description     = "Allow ingress traffic from bastion hosts"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = local.bastion_security_group_id != null ? [local.bastion_security_group_id] : []
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
      Name        = "${local.service_name}-ec2-sg"
      Description = "Security group for EC2 instances in ECS cluster"
    }
  )
}
