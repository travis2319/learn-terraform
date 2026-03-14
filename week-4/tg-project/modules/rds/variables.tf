variable "name"                       { type = string }
variable "vpc_id"                     { type = string }
variable "ec2_sg_id"                  { type = string }
variable "database_subnet_group_name" { type = string }

variable "rds_identifier"             { type = string }
variable "rds_engine"                 { 
    type = string
    default = "mysql"
}
variable "rds_engine_version"         { 
    type = string
    default = "8.0" 
}
variable "rds_family"                 { 
    type = string  
    default = "mysql8.0" 
}
variable "rds_major_engine_version"   { 
    type = string
    default = "8.0" 
}
variable "rds_instance_class"         { 
    type = string  
    default = "db.t3.micro"
}
variable "rds_allocated_storage"      { 
    type = number
    default = 20 
}
variable "rds_db_name"                { type = string }
variable "rds_username"               { type = string }
variable "rds_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}
variable "rds_multi_az"               { 
    type = bool
    default = false 
}
variable "rds_backup_retention_period"{ 
    type = number  
    default = 7 
    }
variable "rds_deletion_protection"    { 
    type = bool    
    default = false 
}
variable "rds_skip_final_snapshot"    { 
    type = bool    
    default = true 
}