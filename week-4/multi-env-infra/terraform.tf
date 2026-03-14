terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
  }

  backend "s3" {
    bucket         = "remote-backend-tf-bucket-456789"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend-tf-table"
    encrypt        = true
  }
}