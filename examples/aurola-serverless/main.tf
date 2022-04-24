provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "wasabi-terraform-tfstate" 
    region = "us-east-1"
    key = "dev/aurola-terraform.tfstate"
    encrypt = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "wasabi-terraform-tfstate"
    key    = "dev/vpc-terraform.tfstate"
    region = "us-east-1"
  }
}
/*
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}*/

variable "db_master_password" {}

module "aurora_mysql_serverless" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name                   = "wasabi-mysqldb"
  engine                 = "aurora-mysql"
  engine_version         = "5.7"
  engine_mode            = "serverless"
  storage_encrypted      = true
  create_random_password = false
  master_password        = var.db_master_password

  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets               = data.terraform_remote_state.vpc.outputs.private_subnets
  create_security_group = true
  allowed_cidr_blocks   = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately    = true
  skip_final_snapshot  = true
  enable_http_endpoint = true
  #  publicly_accessible = true

  #  db_parameter_group_name         = aws_db_parameter_group.example_mysql.id
  #  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example_mysql.id
  #  enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_ssm_parameter" "secret" {
  name        = "/dev/db/password/master"
  description = "root password for wasabidb master"
  type        = "SecureString"
  value       = var.db_master_password

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

/*
resource "aws_db_parameter_group" "example_mysql" {
  name        = "wasabi-aurora-db-mysql-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wasabi-aurora-db-mysql-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "example_mysql" {
  name        = "wasabi-aurora-mysql-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wasabi-aurora-mysql-cluster-parameter-group"
}
*/