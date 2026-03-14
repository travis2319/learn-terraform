resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "remote-backend-tf-bucket-456789" # make unique
  force_destroy = true

  tags = {
    Name = "remote-backend-tf-bucket"
  }
}

resource "aws_s3_bucket_versioning" "my_s3_bucket_versioning" {
  bucket = aws_s3_bucket.my_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_s3_bucket_encryption" {
  bucket = aws_s3_bucket.my_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#aws s3 ls s3://remote-backend-tf-bucket