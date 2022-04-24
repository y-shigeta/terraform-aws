provider "aws" {
  region = "us-east-1"
  profile = "default"
}

/*
terraform {
  backend "local" {
    path = "../vpc/terraform.tfstate"
  }
}
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}
*/
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
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name           = "test-aurora-db-mysql"
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instance_class = "db.r5.large"
  instances = {
    one = {}
  }

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
#  vpc_id  =  "vpc-02f8f6578caab972a"
#  subnets = ["subnet-12345678", "subnet-87654321"]
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets 

#  allowed_security_groups = ["sg-12345678"]
  allowed_cidr_blocks     = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

#  db_parameter_group_name         = "default"
#  db_cluster_parameter_group_name = "default"

#  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
