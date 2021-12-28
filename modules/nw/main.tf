terraform {
  backend "s3" {
    bucket = "shigetastarts-tfstate-pragmatic-terraform"
    key    = "network/terraform.tfstate"
    region = "us-west-1"
  }
}
variable "vpc_cidr_block" {}
variable "availability_zone_0" {}
variable "availability_zone_1" {}

#variable "public_subnet_cidr_block" {}
#variable "private_subnet_cidr_block" {}

# VPC作成
resource "aws_vpc" "example" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

output "aws_vpc_id" {
  value = aws_vpc.example.id
}