remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    region = "eu-west-1"
    bucket = "s3-eu-west-1-ctrainpltf-dev-terraform"
    dynamodb_table = "dyn-eu-west-1-ctrainpltf-dev-terraform"
    key = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
}

inputs = {
  region_name = "eu-west-1"
  solution_name = "ctrainpltf"
  solution_stage = "dev"
  solution_fqn = "ctrainpltf-dev"
  common_tags = {
    "Organization" = "msg systems AG"
    "BusinessUnit" = "Branche Automotive + Manufacturing"
    "Department" = "Automotive/Manufacturing CPG"
    "ManagedBy" = "Terraform"
    "PartOf" = "CloudTrain"
    "Tier" = "Platform"
    "Solution" = "ctrainpltf"
    "Stage" = "dev"
  }
  network_name = "train2023"
  network_cidr = "10.17.0.0/16"
  inbound_traffic_cidrs = [ "0.0.0.0/0" ]
  nat_strategy = "NAT_GATEWAY_AZ"
  zones_to_span = 2
  subnet_templates = [
    {
      name = "web"
      accessibility = "public"
      role = "InternetFacingContainer"
      newbits = 8
      tags = {
        "kubernetes.io/role/elb" = "1"
      }
    },
    {
      name = "nodes"
      accessibility = "private"
      role = "NodeGroupContainer"
      newbits = 4
      tags = {}
    },
    {
      name = "resources"
      accessibility = "private"
      role = "ResourceContainer"
      newbits = 8
      tags = {}
    }
  ]
  kubernetes_version = "1.26"
  kubernetes_cluster_name = "train2023"
  kubernetes_api_access_cidrs = [ "0.0.0.0/0" ]
  node_group_strategy = "MULTI_SINGLE_AZ"
  node_group_templates = [
    {
      enabled = true
      name = "green"
      kubernetes_version = null
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.large", "m6a.large", "m5a.large", "m6i.large" ]
      labels = {}
      taints = []
    },
    {
      enabled = true
      name = "blue"
      kubernetes_version = null
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.xlarge", "m6a.xlarge", "m5a.xlarge", "m6i.xlarge" ]
      labels = {}
      taints = []
    }
  ]
  eks_cluster_admin_role_names = ["cloudtrain-power-user"]
  certificate_name = "train2023"
  domain_name = "train2023-dev.k8s.cloudtrain.aws.msgoat.eu"
  alternative_domain_names = []
  hosted_zone_name = "k8s.cloudtrain.aws.msgoat.eu"
  letsencrypt_account_name = "michael.theis@msg.group"
  cert_manager_enabled = false
  host_name = "train2023-dev.k8s.cloudtrain.aws.msgoat.eu"
  loadbalancer_name = "train2023"
}
