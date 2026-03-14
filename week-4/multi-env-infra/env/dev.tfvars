# ─── Global ───────────────────────────────────────────────────────────────────
env          = "dev"
project_name = "aws-terraform-multi-env"
aws_region   = "us-east-1"

# ─── VPC ──────────────────────────────────────────────────────────────────────
vpc_cidr = "10.0.0.0/16"
azs      = ["us-east-1a", "us-east-1b"]

public_subnets   = ["10.0.1.0/24"]
private_subnets  = ["10.0.2.0/24"]
database_subnets = ["10.0.3.0/24"]

# Single NAT Gateway in dev to save ~$32/month per extra gateway
# single_nat_gateway = true

# ─── EC2 ──────────────────────────────────────────────────────────────────────
ec2_instance_type = "t2.micro"
# ec2_ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1) — update as needed
key_pair_name     = "terraform-key-dev"

# ─── RDS ──────────────────────────────────────────────────────────────────────
rds_identifier        = "${project_name}-dev-rds"
rds_instance_class    = "db.t2.micro"
rds_allocated_storage = 20
rds_engine            = "mysql"
rds_engine_version    = "8.0"
rds_family            = "mysql8.0"
rds_major_engine_version = "8.0"
rds_db_name           = "myappdb-dev"
rds_username          = "admin"

# ⚠️  Never commit real passwords — use environment variable instead:
#    export TF_VAR_rds_password="yourpassword"
rds_password = "XVPJAD8wcG7hr2"  

rds_multi_az                = false  # No HA needed in dev
rds_deletion_protection     = false
rds_skip_final_snapshot     = true   # Fast teardown in dev
rds_backup_retention_period = 1


# vpc_name = "dev-vpc"
# vpc_cidr = "10.0.0.0/16"

# azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
# private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]


# enable_nat_gateway = false
# enable_vpn_gateway = false