# ─────────────────────────────────────────────────────────────────────────────
# VPC  |  terraform-aws-modules/vpc/aws
# Docs: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
# ─────────────────────────────────────────────────────────────────────────────
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "${local.name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  # Public subnets → EC2, Load Balancers
  public_subnets = var.public_subnets

  # Private subnets → App servers (if needed later)
  private_subnets = var.private_subnets

  # Database subnets → RDS (dedicated tier, not same as private)
  # The module auto-creates the aws_db_subnet_group for us
  database_subnets                   = var.database_subnets
  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  # NAT Gateway — single in dev to save cost, one-per-AZ in prod
  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = !var.single_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet tags (useful for EKS later if needed)
  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# EC2 Security Group  (hand-rolled — see README for why)
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "ec2" {
  name        = "${local.name}-ec2-sg"
  description = "EC2 instance security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP in production
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

  tags = {
    Name = "${local.name}-ec2-sg"
  }
}

resource "aws_key_pair" "ec2" {
  key_name   = var.key_pair_name
  public_key = file("${var.key_pair_name}.pub")
}
# ─────────────────────────────────────────────────────────────────────────────
# EC2  |  terraform-aws-modules/ec2-instance/aws
# Docs: https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws
# ─────────────────────────────────────────────────────────────────────────────
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"

  name = "${local.name}-ec2"

  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.ec2.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = module.vpc.public_subnets[0]

  root_block_device = {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "${local.name}-ec2"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# RDS Security Group  (the community RDS module does NOT create SGs for you)
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${local.name}-rds-sg"
  description = "RDS — only accept traffic from EC2 SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-rds-sg"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# RDS  |  terraform-aws-modules/rds/aws
# Docs: https://registry.terraform.io/modules/terraform-aws-modules/rds/aws
# ─────────────────────────────────────────────────────────────────────────────
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.1.0"

  identifier = var.rds_identifier

  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  family               = var.rds_family               # Parameter group family
  major_engine_version = var.rds_major_engine_version # Option group major version
  instance_class       = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_allocated_storage * 2 # autoscaling ceiling

  db_name  = var.rds_db_name
  username = var.rds_username
  # password = var.rds_password
  port = "3306"

  # Use the database subnet group created by the VPC module
  create_db_subnet_group = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  vpc_security_group_ids = [aws_security_group.rds.id]

  # High-availability
  multi_az = var.rds_multi_az

  # Maintenance & backup
  maintenance_window      = "Mon:03:00-Mon:04:00"
  backup_window           = "04:00-05:00"
  backup_retention_period = var.rds_backup_retention_period

  # Monitoring
  monitoring_interval    = 60
  monitoring_role_name   = "${local.name}-rds-monitoring-role"
  create_monitoring_role = true

  # Protection
  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot

  # Storage
  storage_encrypted = true
  storage_type      = "gp3"

  # Parameter group
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = {
    Name = "${local.name}-rds"
  }
}
