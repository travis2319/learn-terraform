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

# NAT Gateway
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway (Elastic IP)"
  value       = aws_eip.nat_eip.public_ip
}

# Security Groups
output "public_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public_sg.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private_sg.id
}

# Public EC2 Instance (Bastion)
output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.my_instance.id
}

output "public_instance_public_ip" {
  description = "Public IP of the bastion EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "public_instance_public_dns" {
  description = "Public DNS of the bastion EC2 instance"
  value       = aws_instance.my_instance.public_dns
}

# Private EC2 Instance
output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private_instance.id
}

output "private_instance_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private_instance.private_ip
}

# SSH Commands
output "ssh_to_bastion" {
  description = "Command to SSH into the bastion (public) instance"
  value       = "ssh -i terraform-ec2-key ubuntu@${aws_instance.my_instance.public_ip}"
}

output "ssh_to_private" {
  description = "Command to SSH into the private instance via bastion"
  value       = "ssh -i terraform-ec2-key -J ubuntu@${aws_instance.my_instance.public_ip} ubuntu@${aws_instance.private_instance.private_ip}"
}
