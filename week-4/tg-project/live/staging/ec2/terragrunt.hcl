include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id         = "vpc-00000000000000000"
    public_subnets = ["subnet-00000000000000000", "subnet-11111111111111111", "subnet-22222222222222222"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  name              = "staging"
  vpc_id            = dependency.vpc.outputs.vpc_id
  public_subnet_id  = dependency.vpc.outputs.public_subnets[0]
  ec2_instance_type = "t3.medium"    # bigger than dev
  key_pair_name     = "terraform-key-staging"
  public_key_path     = "${get_terragrunt_dir()}/../keys/terraform-key-staging.pub"
}