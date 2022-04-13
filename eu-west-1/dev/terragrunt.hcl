remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    region = "eu-west-1"
    bucket = "s3-eu-west-1-ctrainpltf-dev-terraform"
    dynamodb_table = "dyn-eu-west-1-ctrainpltf-dev-terraform"
    key = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
}

inputs = {
  region_name = "eu-west-1"
  solution_name = "ctrainpltf"
  solution_stage = "dev"
  solution_fqn = "ctrainpltf-dev"
  common_tags = {
    "Organization" = "msg systems AG"
    "Department" = "Automotive/Manufacturing Technology + Techniques"
    "ManagedBy" = "Terraform"
    "PartOf" = "CloudTrain"
    "Tier" = "Platform"
    "Solution" = "ctrainpltf"
    "Stage" = "dev"
  }
  network_name = "eks"
  network_cidr = "10.17.0.0/16"
  number_of_zones_to_span = 3
  inbound_traffic_cidrs = [ "0.0.0.0/0" ]
  nat_strategy = "NAT_GATEWAY_SINGLE"
  zones_to_span = 3
  subnets = [
    {
      subnet_name = "lb"
      accessibility = "public"
      newbits = 8
      tags = {}
    },
    {
      subnet_name = "ng"
      accessibility = "private"
      newbits = 4
      tags = {}
    },
    {
      subnet_name = "db"
      accessibility = "private"
      newbits = 8
      tags = {}
    }
  ]
}
