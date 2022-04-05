terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"

}

variable "tipo-instancia" {
  type    = string
  default = "t2.nano"
}


resource "aws_instance" "app_server" {
  ami               = "ami-07eaf2ea4b73a54f6"
  instance_type     = var.tipo-instancia
  availability_zone = "us-east-1a"
  vpc_security_group_ids   = [aws_security_group.allow_ssh.id]

 

  tags = {
    Name = "AppServerInstancee"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.app_server.id
  vpc      = true
}

 output "ip-servidor" {
    value = aws_instance.app_server.public_ip
  }

  resource "aws_security_group" "allow_ssh" {
  name        = "ssl"
  description = "Allow ssh inbound traffic"
  

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}