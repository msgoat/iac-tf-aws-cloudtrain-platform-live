include {
  path = find_in_parent_folders()
}

dependency network {
  config_path = "../network"
}

dependency cluster {
  config_path = "../kubernetes/cluster"
}

dependency ingress {
  config_path = "../kubernetes/ingress"
}

terraform {
  source = "../../../../iac-tf-aws-compute-ec2-modules//modules/application-loadbalancer"
}

inputs = {
  loadbalancer_name = "cloudtrain"
  loadbalancer_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.subnet_template_name == "lb" ]
  target_group_subnet_ids = [ for sn in dependency.network.outputs.subnets : sn.subnet_id if sn.subnet_template_name == "ng" ]
  host_names = [ "cloudtrain.aws.msgoat.eu", "*.cloudtrain.aws.msgoat.eu" ]
  target_group = {
    name = "traefik"
    port = dependency.ingress.outputs.ingress_controller.port
    protocol = dependency.ingress.outputs.ingress_controller.protocol
  }
  target_group_health_check = {
    path = dependency.ingress.outputs.ingress_controller.health_probe_path
    port = dependency.ingress.outputs.ingress_controller.health_probe_port
    protocol = dependency.ingress.outputs.ingress_controller.health_probe_protocol
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 15
  }
  eks_cluster_name = dependency.cluster.outputs.eks_cluster_name
}
