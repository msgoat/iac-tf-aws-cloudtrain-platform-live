include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../../_env/common_providers.hcl"
}

include "k8s_providers" {
  path = "${get_terragrunt_dir()}/../../../../_env/k8s_providers.hcl"
}

dependency network {
  config_path = "../../network"
}

dependency cluster {
  config_path = "../cluster"
}

dependency certificates {
  config_path = "../../tls-certificates"
}

terraform {
  source = "git::https://github.com/msgoat/iac-tf-aws-cloudtrain-modules.git//modules/container/eks/ingress/default"
#  source = "get_terragrunt_dir()/../../../../../../iac-tf-aws-cloudtrain-modules//modules/container/eks/ingress/default"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
  tls_certificate_arn = dependency.certificates.outputs.cm_certificate_arn
  loadbalancer_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "InternetFacingContainer" ]
  target_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.role == "NodeGroupContainer" ]
}
