output "instance_public_ip" {
  description = "IP publico da instancia EC2"
  value       = aws_instance.nginx_public.public_ip
}

output "instance_id" {
  description = "ID da instancia EC2"
  value       = aws_instance.nginx_public.id
}

output "ami_id" {
  description = "ID da AMI utilizada"
  value       = data.aws_ami.amazon_linux_2023.id
}
