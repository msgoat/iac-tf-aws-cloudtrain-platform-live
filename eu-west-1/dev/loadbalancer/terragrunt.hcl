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

dependency dns {
  config_path = "../dns"
}

terraform {
  source = "${local.common_locals.module_root}//modules/network/application-loadbalancer"
}

inputs = {
  loadbalancer_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "InternetFacingContainer" ]
  cm_certificate_arn = dependency.certificates.outputs.cm_certificate_arn
  public_hosted_zone_id = dependency.dns.outputs.hosted_zone_id
}
