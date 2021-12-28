provider "aws" {
  region = "us-west-1"
  profile = "default"
}

module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "4.7.0"
}

module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "~> 4.3"

  account_alias = "awesome-company12"

  minimum_password_length = 37
  require_numbers         = false
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  name          = "yasunori.shigeta"
  force_destroy = true
  create_iam_user_login_profile = false

#  pgp_key = "keybase:test"

  password_reset_required = true
}
