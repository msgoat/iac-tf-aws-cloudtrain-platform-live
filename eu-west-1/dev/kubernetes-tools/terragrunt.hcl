locals {
  common_locals = yamldecode(file(find_in_parent_folders("common_locals.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/common_providers.hcl"
}

include "k8s_providers" {
  path = "${get_terragrunt_dir()}/../../../_env/k8s_providers.hcl"
}

dependency cluster {
  config_path = "../kubernetes-cluster"
}

dependency addons {
  config_path = "../kubernetes-addons"
}

terraform {
  source = "${local.common_locals.module_root}//modules/container/eks/tools"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
  kubernetes_ingress_class_name = dependency.addons.outputs.kubernetes_ingress_class_name
  kubernetes_ingress_controller_type = dependency.addons.outputs.kubernetes_ingress_controller_type
}
