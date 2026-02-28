output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_id" {
    description = "ID of the EC2 instance"
    value       = aws_instance.my_instance.id
}

output "instance_public_dns" {
    description = "Public DNS of the EC2 instance"
    value       = aws_instance.my_instance.public_dns
}

output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_default_vpc.default.id
}

output "security_group_id" {
    description = "ID of the default security group"
    value       = aws_default_security_group.default-sg.id
}

output "key_pair_name" {
    description = "Name of the AWS key pair"
    value       = aws_key_pair.my_key.key_name
}

