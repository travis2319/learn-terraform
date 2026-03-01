output "s3_bucket_name" {
  description = "Name of the s3 Bucket"
  value       = aws_s3_bucket.my_s3_bucket.bucket

}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB Table"
  value       = aws_dynamodb_table.my_dynamodb_table.name
}

output "aws_region" {
  description = "AWS region"
  value       = "us-east-1"
}