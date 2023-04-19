generate "k8s_providers" {
  path      = "k8s_providers.tf"
  if_exists = "terragrunt_overwrite"
  contents = <<EOF
data aws_eks_cluster given {
  name = var.eks_cluster_name
}

data aws_eks_cluster_auth given {
  name = data.aws_eks_cluster.given.name
}

provider kubernetes {
  host                   = data.aws_eks_cluster.given.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.given.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.given.token
}

provider helm {
  kubernetes {
    host                   = data.aws_eks_cluster.given.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.given.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.given.token
  }
}
EOF
}
