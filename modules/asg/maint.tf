resource "aws_autoscaling_group" "example" {
  availability_zones = ["us-west-1b"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  tag {
    key                 = "env"
    value               = "dev"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

#  lifecycle {
#    create_before_destroy = true
#  }
}


data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "example" {
  image_id      = data.aws_ami.example.id
#  image_id      = "ami-01c1168b9f7398306"

  instance_type = "t3.nano"
}
