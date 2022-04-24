provider "aws" {
  region  = "us-west-1"
  profile = "default"
}


# Create EC2 Web server
module "web_server" {
  source        = "../../modules/http_server"
  instance_type = var.instance_type 
  src_globalip = var.src_globalip
  ami = var.ami
}

output "public_dns" {
  value = module.web_server.public_dns
}
