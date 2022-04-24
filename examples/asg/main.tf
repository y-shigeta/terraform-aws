provider "aws" {
  region  = "us-west-1"
  profile = "default"
}

/*
# Create EC2 Web server
module "web_server" {
  source        = "../../modules/http_server"
  instance_type = "t3.micro"
  src_globalip = "60.112.131.181/32"
}

output "public_dns" {
  value = module.web_server.public_dns
}
*/

# Create AutoScalingGroup
module "asg" {
  source = "../../modules/asg"
}
