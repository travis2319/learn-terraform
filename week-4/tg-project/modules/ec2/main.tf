data "aws_ami" "ubuntu_24" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2-sg"
  description = "EC2 instance security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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

  tags = { Name = "${var.name}-ec2-sg" }
}

resource "aws_key_pair" "ec2" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"

  name                   = "${var.name}-ec2"
  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.ec2.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = var.public_subnet_id

  root_block_device = {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = { Name = "${var.name}-ec2" }
}