provider "aws" {
  region = "us-west-1"
#  region = "desired-region"
#  alias = "regional"
  #  shared_credentials_file = "/Users/yas/Credential/log-ec2-linux-keypair.pem"
  profile = "default"
}

module "web_server" {
  source        = "./http_server"
  instance_type = "t3.micro"
}
/*

output "public_dns" {
  value = module.web_server.public_dns
}

module "iam_role_for_ec2" {
  source     = "./modules/iam_role"
  name       = "describe-regions-for-s3"
#  identifier = "s3.amazonaws.com"
  identifier = "*"
#  policy     = 
}

module "s3" {
  source = "./modules/s3"
}
*/

/*
module "nw" {
#  alb_log_bucket = module.s3.alb_log
  source                      = "./modules/nw"
  availability_zone_0         = var.availability_zone_0
  availability_zone_1         = var.availability_zone_1
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_0_cidr_block  = var.public_subnet_0_cidr_block
  public_subnet_1_cidr_block  = var.public_subnet_1_cidr_block
  private_subnet_0_cidr_block = var.private_subnet_0_cidr_block
  private_subnet_1_cidr_block = var.private_subnet_1_cidr_block
}
*/
/*
module "asg" {
  source = "./modules/asg"
}
*/
/*
module "dynamodb" {
  source = "./modules/dynamodb"
}
*/

#module "elb" {
#  source                      = "./modules/elb"
#}
/*
module "ecs" {
  source                      = "./modules/ecs"
  vpc_cidr_block              = var.vpc_cidr_block
}
*/

