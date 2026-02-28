# Key Pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = var.key_pair_name
  public_key = file("${var.key_pair_name}.pub")

  tags = {
    Name = "${var.key_pair_name}"
  }
}

# Virtual Private Cloud (VPC)
resource "aws_default_vpc" "default" {

  tags = {
    Name = "Default VPC"
  }
}

# Network Security Group
resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "Allow 22 (SSH) from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 80 (HTTP) from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 443 (HTTPS) from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.default_sg_name
  }
}

# PUBLIC EC2 INSTANCE
resource "aws_instance" "my_instance" {
  
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  instance_type          = var.instance_type
  ami                    = data.aws_ami.ubuntu.id

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = var.ec2_name
  }
}