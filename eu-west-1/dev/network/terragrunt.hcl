include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/common_providers.hcl"
}

terraform {
  source = "git::https://github.com/msgoat/iac-tf-aws-cloudtrain-modules.git//modules/network/vpc"
#  source = "get_terragrunt_dir()/../../../../../iac-tf-aws-cloudtrain-modules//modules/network/vpc"
}

inputs = {
}
