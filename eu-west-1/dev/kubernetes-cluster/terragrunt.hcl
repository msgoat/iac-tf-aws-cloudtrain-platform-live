locals {
  common_locals = yamldecode(file(find_in_parent_folders("common_locals.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/common_providers.hcl"
}

dependency network {
  config_path = "../network"
}

terraform {
  source = "${local.common_locals.module_root}//modules/container/eks/cluster"
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  node_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "NodeGroupContainer" ]
}
