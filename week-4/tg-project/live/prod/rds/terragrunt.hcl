include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/rds"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id                     = "vpc-00000000000000000"
    database_subnet_group_name = "mock-db-subnet-group"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "ec2" {
  config_path = "../ec2"

  mock_outputs = {
    ec2_sg_id = "sg-00000000000000000"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  name                       = "prod"
  vpc_id                     = dependency.vpc.outputs.vpc_id
  ec2_sg_id                  = dependency.ec2.outputs.ec2_sg_id
  database_subnet_group_name = dependency.vpc.outputs.database_subnet_group_name

  rds_identifier              = "prod-mysql"
  rds_engine                  = "mysql"
  rds_engine_version          = "8.0"
  rds_family                  = "mysql8.0"
  rds_instance_class          = "db.t3.medium"
  rds_db_name                 = "proddb"
  rds_username                = "admin"
  rds_password                = "prodPassword123!"
  rds_allocated_storage       = 100
  rds_multi_az                = true
  rds_deletion_protection     = false
  rds_skip_final_snapshot     = true
  rds_backup_retention_period = 7
}