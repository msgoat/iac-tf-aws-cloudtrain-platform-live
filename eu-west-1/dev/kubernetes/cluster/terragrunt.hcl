include {
  path = find_in_parent_folders()
}

dependency network {
  config_path = "../../network"
}

terraform {
  source = "../../../../../iac-tf-aws-container-eks-modules//modules/eks/cluster"
}

inputs = {
  kubernetes_version = "1.22"
  kubernetes_cluster_name = "cloudtrain"
  kubernetes_api_access_cidrs = [ "0.0.0.0/0" ]
  node_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.subnet_template_name == "ng" ]
  node_groups = [
/*    {
      name = "appsblue"
      kubernetes_version = ""
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.xlarge", "m6a.xlarge", "m6i.xlarge", "m5a.xlarge" ]
      labels = {}
      taints = []
    },
    {
      name = "toolsblue"
      kubernetes_version = ""
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.xlarge", "m6a.xlarge", "m6i.xlarge", "m5a.xlarge" ]
      labels = {}
      taints = [{
        key = "group.msg/workload"
        value = "tools"
        effect = "NO_SCHEDULE"
      }]
    }, */
    {
      name = "appsgreen"
      kubernetes_version = ""
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.large", "m6a.large", "m6i.large", "m5a.large" ]
      labels = {}
      taints = []
    } /*,
    {
      name = "toolsgreen"
      kubernetes_version = ""
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "t3a.large", "m6a.large", "m6i.large", "m5a.large" ]
      labels = {}
      taints = [{
        key = "group.msg/workload"
        value = "tools"
        effect = "NO_SCHEDULE"
      }]
    } */
  ]
}
