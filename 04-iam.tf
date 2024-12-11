#################
# Common Policy #
#################
data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    dynamic "principals" {
      for_each = local.additional_trust_policy_principals

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

data "aws_iam_policy_document" "parameter_store_readonly" {
  statement {
    sid       = "AllowDescribeParams"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ssm:DescribeParameters"]
  }

  statement {
    sid    = "AllowReadUserParams"
    effect = "Allow"

    resources = [
      "arn:aws:ssm:*:*:parameter/shared/*",
      "arn:aws:ssm:*:*:parameter/${local.service_name}/*",
    ]

    actions = [
      "ssm:GetParameter*",
    ]
  }
}

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

resource "aws_iam_role" "ecs_task_role" {
  name        = "ServiceRoleForEcs_${local.service_name}-task"
  path        = "/service-role/ecs-tasks.amazonaws.com/"
  description = "Service Role for ECS Task ${local.service_name}"

  assume_role_policy    = data.aws_iam_policy_document.task_assume_role_policy.json
  force_detach_policies = false
  max_session_duration  = 3600

  tags = merge(
    local.common_tags,
    {
      "Name"        = "ServiceRoleForEcs_${local.service_name}-task"
      "Description" = "Service Role for ECS Task ${local.service_name}"
    },
  )
}

###################
# ECS Task Policy #
###################

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
  count = length(local.allowed_to_assume_cross_account_role_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowCrossAccountAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = local.allowed_to_assume_cross_account_role_arns
  }
}

data "aws_iam_policy_document" "allow_sqs_send_message" {
  count = length(local.allowed_to_send_message_sqs_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowSendMessageSqs"
    effect = "Allow"

    actions = [
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:GetQueueAttributes",
    ]

    resources = local.allowed_to_send_message_sqs_arns
  }
}

data "aws_iam_policy_document" "allow_sqs_receive_message" {
  count = length(local.allowed_to_receive_message_sqs_arns) > 0 ? 1 : 0
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

    resources = local.allowed_to_receive_message_sqs_arns
  }
}

data "aws_iam_policy_document" "allow_cross_account_kms_use" {
  count = length(local.allowed_to_use_cross_account_kms_arns) > 0 ? 1 : 0
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

    resources = local.allowed_to_use_cross_account_kms_arns
  }
}

data "aws_iam_policy_document" "allow_s3_access" {
  count = length(local.allowed_to_access_s3_bucket_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowListS3Bucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = local.allowed_to_access_s3_bucket_arns
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
    resources = [for arn in local.allowed_to_access_s3_bucket_arns : "${arn}/*"]
  }
}

data "aws_iam_policy_document" "allow_sns_publish" {
  count = length(local.allowed_to_publish_sns_topic_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowPublishTopics"
    effect = "Allow"
    actions = [
      "sns:ListTopics",
      "sns:Publish",
    ]
    resources = local.allowed_to_publish_sns_topic_arns
  }
}

data "aws_iam_policy_document" "allow_dynamodb_access" {
  count = length(local.allowed_to_access_dynamodb_arns) > 0 ? 1 : 0

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

    resources = local.allowed_to_access_dynamodb_arns
  }
}

data "aws_iam_policy_document" "allow_lambda_function_url_invoke" {
  count = length(local.allowed_to_invoke_lambda_function_url_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowInvokeLambdaFunctionURL"
    effect = "Allow"

    actions = ["lambda:InvokeFunctionUrl"]

    resources = local.allowed_to_invoke_lambda_function_url_arns
  }
}

data "aws_iam_policy_document" "allow_kms_use" {
  count = length(local.allowed_to_use_kms_arns) > 0 ? 1 : 0
  statement {
    sid    = "AllowDecryptDescribe"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:Decrypt",
    ]

    resources = local.allowed_to_use_kms_arns
  }
}

resource "aws_iam_role_policy" "task_role_cloudwatch_log_appender" {
  name   = "AllowCloudWatchLogAppender"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.cloudwatch_log_appender.json
}

resource "aws_iam_role_policy" "task_role_parameter_store_readonly" {
  name   = "AllowParameterStoreReadonly"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.parameter_store_readonly.json
}

resource "aws_iam_role_policy" "execute_command_policy" {
  name   = "AllowExecuteCommand"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.execute_command.json
}

resource "aws_iam_role_policy" "task_role_kms" {
  count = length(local.allowed_to_use_kms_arns) > 0 ? 1 : 0

  name   = "AllowKMSUsage"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_kms_use[0].json
}

resource "aws_iam_role_policy" "allow_assume_cross_account_role_policy" {
  count = length(local.allowed_to_assume_cross_account_role_arns) > 0 ? 1 : 0

  name   = "AllowAssumeCrossAccountRole"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_assume_cross_account_role[0].json
}

resource "aws_iam_role_policy" "allow_sqs_send_message_policy" {
  count = length(local.allowed_to_send_message_sqs_arns) > 0 ? 1 : 0

  name   = "AllowSQSSendMessage"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_sqs_send_message[0].json
}

resource "aws_iam_role_policy" "allow_sqs_receive_message_policy" {
  count = length(local.allowed_to_receive_message_sqs_arns) > 0 ? 1 : 0

  name   = "AllowSQSReceiveMessage"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_sqs_receive_message[0].json
}

resource "aws_iam_role_policy" "allow_use_cross_account_kms" {
  count = length(local.allowed_to_use_cross_account_kms_arns) > 0 ? 1 : 0

  name   = "AllowCrossAccountKMSUsage"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_cross_account_kms_use[0].json
}

resource "aws_iam_role_policy" "allow_sns_publish_policy" {
  count = length(local.allowed_to_publish_sns_topic_arns) > 0 ? 1 : 0

  name   = "AllowSNSPublish"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_sns_publish[0].json
}

resource "aws_iam_role_policy" "allow_s3_access_policy" {
  count = length(local.allowed_to_access_s3_bucket_arns) > 0 ? 1 : 0

  name   = "AllowS3Access"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_s3_access[0].json
}

resource "aws_iam_role_policy" "allow_dynamodb_access_policy" {
  count = length(local.allowed_to_access_dynamodb_arns) > 0 ? 1 : 0

  name   = "AllowDynamoDBAccess"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_dynamodb_access[0].json
}

resource "aws_iam_role_policy" "allow_function_url" {
  count = length(local.allowed_to_invoke_lambda_function_url_arns) > 0 ? 1 : 0

  name   = "AllowLambdaFunctionURLInvocation"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_lambda_function_url_invoke[0].json
}

######################
# ECS Execution Role #
######################

resource "aws_iam_role" "ecs_execution_role" {
  name               = "ServiceRoleForEcs_${local.service_name}-execution"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}

data "aws_iam_policy_document" "execution_role_base" {
  statement {
    sid       = "AllowToPullECRImage"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
  }

  statement {
    sid    = "AllowLimitedPutEcsLog"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = merge(
      [aws_cloudwatch_log_group.log_group_ecs.arn],
      [
        for k, v in aws_cloudwatch_log_group.log_group_apps : v.arn
      ]
    )
  }
}

resource "aws_iam_role_policy" "execution_role_base" {
  role   = aws_iam_role.ecs_execution_role.name
  policy = data.aws_iam_policy_document.execution_role_base.json
}

resource "aws_iam_role_policy" "execution_role_cloudwatch_log_appender" {
  role   = aws_iam_role.ecs_execution_role.name
  policy = data.aws_iam_policy_document.cloudwatch_log_appender.json
}

resource "aws_iam_role_policy" "execution_role_parameter_store_readonly" {
  role   = aws_iam_role.ecs_execution_role.name
  policy = data.aws_iam_policy_document.parameter_store_readonly.json
}

#####################
# EC2 Instance Role #
#####################

resource "aws_iam_role" "ec2_instance_role" {
  name        = "ServiceRoleForEc2_${local.service_name}-instance"
  description = "Service Role for EC2 Instance ${local.service_name}"

  assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name = "InstanceProfileForEc2_${local.service_name}-instance"
  role = aws_iam_role.ec2_instance_role.id
}

data "aws_iam_policy_document" "ec2_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}
