#################
# Common Policy #
#################

data "aws_iam_policy_document" "cloudwatch_log_appender" {
  statement {
    sid    = "AllowLimitedPutLog"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:PutRetentionPolicy",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.cloudwatch_prefix}/*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.cloudwatch_prefix}/*:log-stream:*",
    ]
  }
}

#################
# ECS Task Role #
#################

# ECS Task IAM Role

data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [local.aws_service_name]
    }

    dynamic "principals" {
      for_each = var.additional_trust_policy_principals

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "ServiceRoleForEcs_${var.service_name}-task"
  path        = "/service-role/${local.aws_service_name}/"
  description = "Service Role for ECS Task ${var.service_name}"

  assume_role_policy    = data.aws_iam_policy_document.ecs_task_role.json
  force_detach_policies = false
  max_session_duration  = 3600

  tags = merge(
    var.additional_tags,
    {
      "Name"          = "ServiceRoleForEcs_${var.service_name}-task"
      "Environment"   = var.environment
      "Description"   = "Service Role for ECS Task ${var.service_name}"
      "ManagedBy"     = "Terraform"
    },
  )
}

# ECS Task IAM Policy

data "aws_iam_policy_document" "execute_command" {
  statement {
    sid    = "AllowExecuteCommand"
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "allow_assume_cross_account_role" {
  count = length(var.cross_account_role_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowCrossAccountAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = var.cross_account_role_arns
  }
}

data "aws_iam_policy_document" "sqs_allow_send_message" {
  count = length(var.allowed_to_send_message_sqs_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowSendMessageSqs"
    effect = "Allow"

    actions = [
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:GetQueueAttributes",
    ]

    resources = var.allowed_to_send_message_sqs_arns
  }
}

data "aws_iam_policy_document" "sqs_allow_receive_message" {
  count = length(var.allowed_to_receive_message_sqs_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowReceiveMessageSqs"
    effect = "Allow"

    actions = [
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueAttributes",
    ]

    resources = var.allowed_to_receive_message_sqs_arns
  }
}

data "aws_iam_policy_document" "cross_account_kms_allow_use" {
  count = length(var.allowed_to_use_cross_account_kms_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowUseCrossAccountKMS"
    effect = "Allow"

    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:CreateGrant"
    ]

    resources = var.allowed_to_use_cross_account_kms_arns
  }
}

data "aws_iam_policy_document" "s3_allow_access" {
  count = length(var.allowed_s3_bucket_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowListS3Bucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = var.allowed_s3_bucket_arns
  }

  statement {
    sid    = "AllowAccessS3object"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetEncryptionConfiguration",
    ]
    resources = [for arn in var.allowed_s3_bucket_arns : "${arn}/*"]
  }
}

data "aws_iam_policy_document" "sns_allow_publish" {
  count = length(var.allowed_to_publish_sns_topic_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowPublishTopics"
    effect = "Allow"
    actions = [
      "sns:ListTopics",
      "sns:Publish",
    ]
    resources = var.allowed_to_publish_sns_topic_arns
  }
}

data "aws_iam_policy_document" "dynamodb_allow_access" {
  count = length(var.allowed_to_access_dynamodb_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowAccessDynamoDB"
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]

    resources = var.allowed_to_access_dynamodb_arns
  }
}

data "aws_iam_policy_document" "allow_function_url" {
  count = length(var.allowed_lambda_function_url_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowInvokeLambdaFunctionURL"
    effect = "Allow"

    actions = ["lambda:InvokeFunctionUrl"]

    resources = var.allowed_lambda_function_url_arns
  }
}

#####################
# EC2 Instance Role #
#####################

resource "aws_iam_role" "ec2_instance_role" {
  name               = "ServiceRoleForEc2_${var.service_name}-instance"
  description = "Service Role for EC2 Instance ${var.service_name}"

  assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name               = "InstanceProfileForEc2_${var.service_name}-instance"
  role  = aws_iam_role.ec2_instance_role.id
}

data "aws_iam_policy_document" "ec2_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}
