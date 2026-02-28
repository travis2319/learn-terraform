resource "aws_s3_bucket" "example" {
  bucket = "remote-backend-tf-bucket"

  tags = {
    Name        = "remote-backend-tf-bucket"
  }
}
#aws s3 ls s3://remote-backend-tf-bucket