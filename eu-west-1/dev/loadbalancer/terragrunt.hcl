locals {
  common_locals = yamldecode(file(find_in_parent_folders("common_locals.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/common_providers.hcl"
}

dependency certificates {
  config_path = "../tls-certificates"
}

dependency network {
  config_path = "../network"
}

terraform {
  source = "${local.common_locals.module_root}//modules/network/application-loadbalancer2"
}

inputs = {
  loadbalancer_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "InternetFacingContainer" ]
  target_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "NodeGroupContainer" ]
  cm_certificate_arn = dependency.certificates.outputs.cm_certificate_arn
}
