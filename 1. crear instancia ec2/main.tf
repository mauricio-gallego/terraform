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

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsexample.id
  instance_id = aws_instance.app_server.id
}

resource "aws_instance" "app_server" {
  ami               = "ami-07eaf2ea4b73a54f6"
  instance_type     = var.tipo-instancia
  availability_zone = "us-east-1a"
 

  tags = {
    Name = "ExampleAppServerInstancee"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.app_server.id
  vpc      = true
}

resource "aws_ebs_volume" "ebsexample" {
  availability_zone = "us-east-1a"
  size              = 10

  tags = {
    Name = "HelloWorld"
  }

 }
 output "ip-servidor" {
    value = aws_instance.app_server.public_ip
  }