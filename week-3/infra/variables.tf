variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "key_pair_name" {
    description = "Name of the AWS key pair"
    default = "terraform-ec2-key"
}

variable "cidr_block" {
  description = "cidr of the network"
  default = "10.1.0.0/16"
}
variable "vpc_name" {
  description = "Name tag for the VPC"
  default = "main-vpc"
}

variable "default_sg_name" {
  description = "Name tag for the default security group"
  default = "default-sg"
}

variable "instance_type" {
    description = "EC2 instance type"
    default = "t2.micro"
}

variable "volume_size" {
  description = "Volume size in GB"
  default = 8
}

variable "volume_type" {
  description = "Volume type"
  default = "gp2"
}

variable "ec2_name" {
  description = "Name tag for the EC2 instance"
  default = "Terraform-EC2"
  
}