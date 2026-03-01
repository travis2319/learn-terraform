terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.34.0"
    }
  }

  backend "s3" {
    bucket         = "remote-backend-tf-bucket-232719"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend-tf-table"
    encrypt        = true
  }
}