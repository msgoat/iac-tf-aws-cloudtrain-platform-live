include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../../_env/common_providers.hcl"
}

dependency network {
  config_path = "../../network"
}

terraform {
#  source = "git::https://github.com/msgoat/iac-tf-aws-cloudtrain-modules.git//modules/container/eks/cluster"
  source = "get_terragrunt_dir()/../../../../../../iac-tf-aws-cloudtrain-modules//modules/container/eks/cluster"
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  node_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "NodeGroupContainer" ]
}
