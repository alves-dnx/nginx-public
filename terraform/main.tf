terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Região injetada via variável de ambiente AWS_REGION
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = var.security_group_name
  description = "Security group para instancia nginx-public"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = var.security_group_name
    Project = var.project_name
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf update -y
    dnf install -y git docker
    systemctl start docker
    systemctl enable docker
    cd /opt
    git clone https://github.com/alves-dnx/nginx-public.git
    cd /opt/nginx-public
    docker build -t nginx-public:latest .
    docker run -d \
      --name nginx-public \
      --restart unless-stopped \
      -p 80:80 \
      nginx-public:latest
  EOF
}

resource "aws_instance" "nginx_public" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = base64encode(local.user_data)

  tags = {
    Name    = var.instance_name
    Project = var.project_name
  }
}
