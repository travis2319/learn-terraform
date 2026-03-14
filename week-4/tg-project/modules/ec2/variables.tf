variable "name"             { type = string }
variable "vpc_id"           { type = string }
variable "public_subnet_id" { type = string }
variable "ec2_instance_type"{ 
    type = string
    default = "t3.micro"
}
variable "key_pair_name"    { type = string }
variable "public_key_path" { type = string }