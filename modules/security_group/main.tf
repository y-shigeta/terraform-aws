variable "name" {}
variable "vpc_id" {}
variable "port" {}
variable "cidr_blocks" {
  type = list(string)
}

#Security Group作成
module "http_sg" {
  source      = "./ingress"
  name        = "http-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./ingress"
  name        = "https-sg"
  vpc_id      = aws_vpc.example.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./ingress"
  name        = "http-redirect-sg"
  vpc_id      = aws_vpc.example.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

output "security_group_id" {
  value = http_sg.id
  value = https_sg.id
  value = http_redirect_sg.id
}
