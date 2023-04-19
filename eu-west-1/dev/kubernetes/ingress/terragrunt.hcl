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
  skip_outputs = true
}

dependency certificates {
  config_path = "../../tls-certificates"
}

terraform {
  source = "get_terragrunt_dir()/../../../../../../iac-tf-aws-cloudtrain-modules//modules/container/eks/tools/ingress/nginx"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
  load_balancer_strategy = "INGRESS_VIA_ALB"
  tls_certificate_arn = dependency.certificates.outputs.cm_certificate_arn
}
