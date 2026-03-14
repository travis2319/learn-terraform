# ─── Global ───────────────────────────────────────────────────────────────────
variable "env" {
  description = "Deployment environment (dev | staging | prod)"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

# ─── VPC ──────────────────────────────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets (one per AZ)"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway (saves cost in dev)"
  type        = bool
  default     = true
}

# ─── EC2 ──────────────────────────────────────────────────────────────────────
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

# variable "ec2_ami" {
#   description = "AMI ID for the EC2 instance (Amazon Linux 2023 recommended)"
#   type        = string
# }

variable "key_pair_name" {
  description = "Name of the existing EC2 key pair for SSH access"
  type        = string
}

# ─── RDS ──────────────────────────────────────────────────────────────────────
variable "rds_identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "rds_engine" {
  description = "RDS engine (mysql | postgres)"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0"
}

variable "rds_family" {
  description = "DB parameter group family (e.g. mysql8.0)"
  type        = string
  default     = "mysql8.0"
}

variable "rds_major_engine_version" {
  description = "Major engine version for option group (e.g. 8.0)"
  type        = string
  default     = "8.0"
}

variable "rds_db_name" {
  description = "Name of the initial database"
  type        = string
}

variable "rds_username" {
  description = "Master username for RDS"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "Master password for RDS (use TF_VAR_rds_password in CI/CD)"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for RDS (always true in prod)"
  type        = bool
  default     = false
}

variable "rds_deletion_protection" {
  description = "Prevent accidental RDS deletion"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on destroy (set false in prod)"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "Days to retain automated backups"
  type        = number
  default     = 1
}
