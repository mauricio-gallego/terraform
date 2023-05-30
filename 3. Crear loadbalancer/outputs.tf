output "ip-publica-servidor" {
  description = "IP PUBLICA SERVIDOR WEB"
  value       = aws_instance.app_server.private_ip
  
}


