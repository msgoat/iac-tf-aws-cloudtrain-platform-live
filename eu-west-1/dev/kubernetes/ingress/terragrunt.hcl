include {
  path = find_in_parent_folders()
}

dependency cluster {
  config_path = "../cluster"
}

terraform {
  source = "../../../../../iac-tf-aws-container-eks-modules//modules/eks/tools/ingress/traefik"
}

inputs = {
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
}
