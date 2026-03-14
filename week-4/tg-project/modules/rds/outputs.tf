output "rds_endpoint"    { value = aws_db_instance.rds.endpoint }
output "rds_db_name"     { value = aws_db_instance.rds.db_name }
output "rds_port"        { value = aws_db_instance.rds.port }
output "rds_instance_id" { value = aws_db_instance.rds.identifier }