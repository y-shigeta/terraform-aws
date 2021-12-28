
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "shigetastarts-tfstate-pragmatic-terraform"
    key    = "network/terraform.tfstate"
    region = "us-west-1"
#    region = aws.regional
  }
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "private_subnet_0_id" {
  default = ""
}
variable "private_subnet_1_id" {
  default = ""
}
variable "target_group_arn" {
  default = ""
}

resource "aws_ecs_cluster" "example" {
  name = "example"
}

resource "aws_ecs_task_definition" "example" {
  family                   = "example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
#  container_definitions    = file("./modules/ecs/container_definitions.json")
  container_definitions    = file("./container_definitions.json")
}

resource "aws_ecs_service" "example" {
  name                              = "example"
  cluster                           = aws_ecs_cluster.example.arn
  task_definition                   = aws_ecs_task_definition.example.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
#      data.terraform_remote_state.network.outputs.private_subnet_0_id,
#      data.terraform_remote_state.network.outputs.private_subnet_1_id,
#      aws_subnet.private_0.id,
#      aws_subnet.private_1.id,
      "subnet-01b464bd3c8182de2",
      "subnet-03abccd6fa72e5d52"
    ]
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-1:139082967877:targetgroup/example/0c224c51d3fb10af"
#    target_group_arn = data.terraform_remote_state.network.outputs.aws_lb_target_group.example.arn
    container_name   = "example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

module "nginx_sg" {
  source      = "./security_group"
  name        = "nginx-sg"
#  vpc_id      = aws_vpc.example.id
#  vpc_id      =   module.nw.aws_vpc_id
  vpc_id      = "vpc-0608d380a5def64dd"
  #vpc_id      = data.terraform_remote_state.network.outputs.aws_vpc_id
  port        = 80
  #cidr_blocks = [aws_vpc.example.cidr_block]
  cidr_blocks = [var.vpc_cidr_block]
#  depends_on = [aws_vpc.example]
}
