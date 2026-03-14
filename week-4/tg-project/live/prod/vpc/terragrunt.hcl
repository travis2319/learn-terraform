include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  name               = "prod"
  vpc_cidr           = "10.1.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnets    = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
  database_subnets   = ["10.1.21.0/24", "10.1.22.0/24", "10.1.23.0/24"]
  single_nat_gateway = false   # one NAT per AZ for high availability
}