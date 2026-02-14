# Key Pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = "ec2-terraform-key"
  public_key = file("terraform-ec2-key.pub")
}

# VPC 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table Association
resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# -------------------
# PUBLIC SECURITY GROUP
# -------------------
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "security groups for public subnet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "public-sg"
  }
}

# INGRESS RULES
resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH"
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS"
}

# EGRESS RULES
resource "aws_vpc_security_group_egress_rule" "public_all_outbound" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}


# PRIVATE SECURITY GROUP
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "security group for private subnet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "private-sg"
  }
}

# Ingress rule
resource "aws_vpc_security_group_ingress_rule" "private_from_public" {
  security_group_id            = aws_security_group.private_sg.id
  referenced_security_group_id = aws_security_group.public_sg.id
  ip_protocol                  = "-1"
  description                  = "Allow all traffic from public security group"
}

# Egress Rule
resource "aws_vpc_security_group_egress_rule" "private_all_outbound" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}


# EC2 INSTANCE
resource "aws_instance" "my_instance" {
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  instance_type          = "t2.micro"
  ami                    = "ami-0360c520857e3138f" # Ubuntu 24.04 LTS

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Terraform-EC2"
  }
}