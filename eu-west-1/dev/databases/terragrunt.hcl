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

dependency namespace {
  config_path = "../workload-namespaces"
}

terraform {
  source = "${local.common_locals.module_root}//modules/cloudtrain/databases"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
  kubernetes_namespace_name = dependency.namespace.outputs.eks_cluster_name
}