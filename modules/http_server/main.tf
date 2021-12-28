/*
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
*/
provider "aws" {
  region = "us-west-1"
  profile = "default"
}
variable "instance_type" {
  default = "t3.nano"
}
variable "src_globalip" {
  default = "60.112.131.181/32"
}

variable "ami" {
  default = {
    rhel7 = "RHEL-7.?_HVM-????????-x86_64-*-GP2"
    win = "Windows_Server-2019-Japanese-Full-Base"
    cent8 = "ami-01c1168b9f7398306" # CentOS 8 for us-west-1 
    cent7 = "ami-08d2d8b00f270d03b" # CentOS 7 for us-west-1
    ubuntsu20 = "ami-039da1612f6f41296" # Ubuntsu20.4 LTS for us-west-1
  }
}
/*
variable "images" {
    default = {
        us-east-1 = "ami-1ecae776"
        us-west-2 = "ami-e7527ed7"
        us-west-1 = "ami-d114f295"
        eu-west-1 = "ami-a10897d6"
        eu-central-1 = "ami-a8221fb5"
        ap-southeast-1 = "ami-68d8e93a"
        ap-southeast-2 = "ami-fd9cecc7"
        ap-northeast-1 = "ami-cbf90ecb"
        sa-east-1 = "ami-b52890a8"
    }
}
*/
data "aws_ami" "web" {
  most_recent = true
  owners      = ["amazon"]
}
#data "aws_iam_roles" "roles" {}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
#  owners      = ["aws-marketplace"]

  filter {
# Amazon Linux
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "default" {
  vpc_security_group_ids = [aws_security_group.default.id]
  ami = var.ami.cent7
  instance_type          = var.instance_type
  user_data = file("./user_data.sh")
#  user_data = file("./http_server/user_data.sh")
  key_name = "log-ec2-linux-keypair"
  tags = {
    Name = var.instance_name
  }
#  user_data = <<EOF
#    #!/bin/bash
#    yum install -y httpd
#    systemctl start httpd.service
#EOF
/*
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      host = aws_instance.default.public_dns
#      private_key = file("~/.ssh/id_rsa.pub")
      private_key = file("~/Credential/ec2-linux-keypair.pem")
    }
    inline = [
      "sudo yum install -y python"
    ]
  }
  provisioner "local-exec" {
    working_dir = "./ansible-tomcat-sqldb/"
    command     = "ansible-playbook -i inventory nginx.yaml"
  }
*/
}

resource "aws_security_group" "default" {
  name = "ec2"

  ingress {
#    from_port = 80
#    to_port = 80
#    protocol = "tcp"
    from_port = 0
    to_port = 0
    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = [var.src_globalip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "instance_name" {
  description = "dev server"
  type = string
  default = "default name"
}

output "public_dns" {
  value = aws_instance.default.public_dns
}
