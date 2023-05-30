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
  default = "t2.micro"
}


resource "aws_instance" "app_server" {
  ami                    = "ami-07d02ee1eeb0c996c"
  instance_type          = var.tipo-instancia
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
echo "<html><h1>Welcome to Aapache Web Server</h2></html>" > /var/www/html/index.html
service start apache2

EOF



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

resource "aws_security_group" "allow_http" {
  name        = "http"
  description = "Allow http inbound traffic"


  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  


  tags = {
    Name = "allow_http"
  }
}
