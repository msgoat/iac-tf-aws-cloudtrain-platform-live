include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/common_providers.hcl"
}

dependency load_balancer {
  config_path = "../kubernetes/ingress"
}

terraform {
  source = "get_terragrunt_dir()/../../../../../iac-tf-aws-cloudtrain-modules//modules/dns/record-for-alb"
}

inputs = {
  alb_arn = dependency.load_balancer.outputs.alb_arn
}
