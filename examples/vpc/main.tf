provider "aws" {
  region = "us-east-1"
  profile = "default"
}

/*
terraform {
  backend "local" {
    path = "../vpc/terraform.tfstate"
  }
}*/

terraform {
  backend "s3" {
    bucket = "wasabi-terraform-tfstate" 
    region = "us-east-1"
    key = "dev/vpc-terraform.tfstate"
    encrypt = true
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "wasabi-vpc"
  cidr = "10.2.0.0/24"

/*
  azs             = ["us-east-1c"]
  private_subnets = ["10.2.0.0/26"]
  public_subnets  = ["10.2.0.128/26"]

*/
  azs             = ["us-east-1c", "us-east-1d"]
  private_subnets = ["10.2.0.0/26", "10.2.0.64/26"]
  public_subnets  = ["10.2.0.128/26", "10.2.0.192/26"]

  enable_nat_gateway = true
#  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "public_subnets_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}
output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}
