include "root" {
  path = find_in_parent_folders()
}

include "common_providers" {
  path = "${get_terragrunt_dir()}/../../../../_env/common_providers.hcl"
}

include "k8s_providers" {
  path = "${get_terragrunt_dir()}/../../../../_env/k8s_providers.hcl"
}

dependency cluster {
  config_path = "../cluster"
}

dependency addons {
  config_path = "../addons"
}

dependency ingress {
  config_path = "../ingress"
}

terraform {
#  source = "git::https://github.com/msgoat/iac-tf-aws-cloudtrain-modules.git//modules/container/eks/tools"
  source = "get_terragrunt_dir()/../../../../../../iac-tf-aws-cloudtrain-modules//modules/container/eks/tools"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
}
