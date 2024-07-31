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
    security_groups = [local.alb_id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
