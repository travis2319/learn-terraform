resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "remote-backend-tf-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "remote-backend-tf-table"
  }
}