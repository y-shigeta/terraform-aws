provider "aws" {
  region = "us-west-1"
  profile = "default"
}

module "nw" {
#  alb_log_bucket = module.s3.alb_log
  source                      = "../../modules/nw"
  availability_zone_0         = var.availability_zone_0
  availability_zone_1         = var.availability_zone_1
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_0_cidr_block  = var.public_subnet_0_cidr_block
  public_subnet_1_cidr_block  = var.public_subnet_1_cidr_block
  private_subnet_0_cidr_block = var.private_subnet_0_cidr_block
  private_subnet_1_cidr_block = var.private_subnet_1_cidr_block
}
