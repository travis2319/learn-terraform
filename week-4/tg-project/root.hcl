locals {
  aws_region = "us-east-1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
}
EOF
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.35"
    }
  }

  backend "s3" {
    bucket         = "remote-backend-tf-bucket-456789"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "remote-backend-tf-table"
  }
}
EOF
}

# generate "provider" {
#   path      = "provider.tf"
#   if_exists = "overwrite"
#   contents = <<EOF
# provider "aws" {
#   region              = "us-east-1"
# }
# EOF
# }

# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = <<EOF
# terraform {
#   backend "s3" {
#     bucket         = "remote-backend-tf-bucket-456789"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "remote-backend-tf-table"
#   }
# }
# EOF
# }