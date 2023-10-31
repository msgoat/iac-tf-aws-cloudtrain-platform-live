# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

module backend {
#  source = "git::https://github.com/msgoat/iac-tf-aws-cloudtrain-modules.git//modules/terraform/remote-state"
  source = "../../../../iac-tf-aws-cloudtrain-modules/modules/terraform/remote-state"
  region_name = "eu-west-1"
  solution_name = "ctrainpltf"
  solution_stage = "dev"
  solution_fqn = "ctrainpltf-dev"
  common_tags = {
    "Organization" = "msg systems AG"
    "Department" = "Automotive/Manufacturing CPG"
    "ManagedBy" = "Terraform"
    "PartOf" = "CloudTrain"
    "Tier" = "Platform"
    "Solution" = "ctrainpltf"
    "Stage" = "dev"
  }
}
