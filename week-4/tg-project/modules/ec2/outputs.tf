output "instance_id"        { value = module.ec2.id }
output "public_ip"          { value = module.ec2.public_ip }
output "ec2_sg_id"          { value = aws_security_group.ec2.id }