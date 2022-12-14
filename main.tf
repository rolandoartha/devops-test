terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
resource "aws_instance" "centos_instance" {
  ami                         = "ami-002070d43b0a4f171"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer
  availability_zone           = "us-east-1"
  associate_public_ip_address = true

  tags = {
    Name = "nodejs app"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("key/mykey.pub")
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  vpc_id = data.aws_vpc.default
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "public access"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
}
