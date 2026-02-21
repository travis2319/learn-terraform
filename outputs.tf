# VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Subnets
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

# Internet Gateway
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# Security Groups
output "public_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public_sg.id
}

# EC2 Instance
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.my_instance.public_dns
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.my_instance.private_ip
}

# SSH Command
output "ssh_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i terraform-ec2-key ubuntu@${aws_instance.my_instance.public_ip}"
}
