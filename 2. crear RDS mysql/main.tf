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



resource "aws_db_instance" "dbmysql" {
  identifier             = "dbmysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7.25"
  username               = var.db_username
  password               = var.db_password
  //db_subnet_group_name   = aws_db_subnet_group.education.name
  //vpc_security_group_ids = [aws_security_group.rds.id]
 // parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.dbmysql.address
  
}

output "RDS-username" {
    description = "RDS instance username"
    value = aws_db_instance.dbmysql.username
    
}