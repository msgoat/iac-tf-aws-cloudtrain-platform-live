# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

module backend {
  source = "../../../../iac-tf-aws-backend-module"
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
}
