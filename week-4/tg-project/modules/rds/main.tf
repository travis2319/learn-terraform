# ─────────────────────────────────────────────────────────────────────────────
# RDS Security Group
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "RDS - only accept traffic from EC2 SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-rds-sg" }
}

# ─────────────────────────────────────────────────────────────────────────────
# RDS Parameter Group
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_db_parameter_group" "rds" {
  name        = "${var.name}-rds-pg"
  family      = var.rds_family
  description = "${var.name} RDS parameter group"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = { Name = "${var.name}-rds-pg" }
}

# ─────────────────────────────────────────────────────────────────────────────
# RDS Instance
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_db_instance" "rds" {
  identifier        = var.rds_identifier
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_allocated_storage * 2
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.rds_db_name
  username = var.rds_username
  password = var.rds_password           # ← plain password, no Secrets Manager
  port     = 3306

  db_subnet_group_name   = var.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds.name

  multi_az                = var.rds_multi_az
  maintenance_window      = "Mon:03:00-Mon:04:00"
  backup_window           = "04:00-05:00"
  backup_retention_period = var.rds_backup_retention_period

  monitoring_interval = 0               # ← no IAM role needed

  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot
  final_snapshot_identifier    = var.rds_skip_final_snapshot ? null : "${var.rds_identifier}-final-snapshot"  # ← add this

  tags = { Name = "${var.name}-rds" }
}

# resource "aws_security_group" "rds" {
#   name        = "${var.name}-rds-sg"
#   description = "RDS - only accept traffic from EC2 SG"
#   vpc_id      = var.vpc_id

#   ingress {
#     description     = "MySQL from EC2"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [var.ec2_sg_id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = { Name = "${var.name}-rds-sg" }
# }

# module "rds" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "7.1.0"

#   identifier           = var.rds_identifier
#   engine               = var.rds_engine
#   engine_version       = var.rds_engine_version
#   family               = var.rds_family
#   major_engine_version = var.rds_major_engine_version
#   instance_class       = var.rds_instance_class

#   allocated_storage     = var.rds_allocated_storage
#   max_allocated_storage = var.rds_allocated_storage * 2

#   db_name  = var.rds_db_name
#   username = var.rds_username
#   password = var.rds_password                      # ← add password variable
#   manage_master_user_password = false              # ← prevent password from being changed on updates
#   port     = "3306"

#   create_db_subnet_group = false
#   db_subnet_group_name   = var.database_subnet_group_name
#   vpc_security_group_ids = [aws_security_group.rds.id]

#   multi_az                = var.rds_multi_az
#   maintenance_window      = "Mon:03:00-Mon:04:00"
#   backup_window           = "04:00-05:00"
#   backup_retention_period = var.rds_backup_retention_period

#   monitoring_interval    = 0
#   # monitoring_role_name   = "${var.name}-rds-monitoring-role"
#   create_monitoring_role = false

#   deletion_protection = var.rds_deletion_protection
#   skip_final_snapshot = var.rds_skip_final_snapshot
#   storage_encrypted   = true
#   storage_type        = "gp3"

#   parameters = [
#     { name = "character_set_client", value = "utf8mb4" },
#     { name = "character_set_server", value = "utf8mb4" }
#   ]

#   tags = { Name = "${var.name}-rds" }
# }