data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_vpc" "this" {
  id = local.vpc_id
}

data "aws_alb_target_group" "this" {
  id = local.alb_id
}
