locals {
  common_name = "train2024"
}

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
    "BusinessUnit" = "Branche Automotive"
    "Department" = "PG Cloud"
    "ManagedBy" = "Terraform"
    "PartOf" = "CloudTrain"
    "Tier" = "Platform"
    "Solution" = "ctrainpltf"
    "Stage" = "dev"
  }
  network_name = local.common_name
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
  kubernetes_version = "1.29"
  kubernetes_cluster_name = local.common_name
  kubernetes_api_access_cidrs = [ "0.0.0.0/0" ]
  node_group_strategy = "MULTI_SINGLE_AZ"
  node_group_templates = [
    {
      enabled = true
      name = "blue"
      kubernetes_version = null
      min_size = 1
      max_size = 4
      desired_size = 1
      disk_size = 100
      capacity_type = "SPOT"
      instance_types = [ "m6g.xlarge", "t4g.xlarge", "m7g.xlarge" ]
      labels = {}
      taints = []
      instance_type = "BOTTLEROCKET_ARM_64"
    }
  ]
  eks_cluster_admin_role_names = ["cloudtrain-power-user", "role-eu-west-1-cloudtrain-codebuild"]
  certificate_name = local.common_name
  domain_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  alternative_domain_names = []
  hosted_zone_name = "k8s.cloudtrain.aws.msgoat.eu"
  letsencrypt_account_name = "michael.theis@msg.group"
  cert_manager_enabled = true
  host_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  loadbalancer_name = local.common_name
  # Enables/disables opentracing/jaeger support in kubernetes-ingress controllers and tools.
  # Needs to be disabled until tracing stack is deployed to kubernetes-cluster
  jaeger_enabled = false
  # Jaeger service endpoint (here: OpenTelemetry on Jaeger collector)
  jaeger_agent_host = "tracing-jaeger-collector.tracing"
  # Jaeger protocol endpoint port (here: OpenTelemetry Protocol via GRPC)
  jaeger_agent_port = 4317
  # Controls if OpenTelemetry support should be enabled
  opentelemetry_enabled = true
  # Host name of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true
  opentelemetry_collector_host = "tracing-jaeger-collector.tracing"
  # Port number of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true
  opentelemetry_collector_port = 4317
  # Enables/disables prometheus operator support in all deployments
  # Needs to be disabled until monitoring stack is deployed to kubernetes-cluster
  prometheus_operator_enabled = false
  # Additional workload-namespaces to create for actual workload
  kubernetes_namespace_templates = [
    {
      name = "cloudtrain"
      labels = {}
      network_policy_enforced = false
    }
  ]
  host_names = [ "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu" ]
  # Kubernetes add-ons
  addon_aws_auth_enabled = true
  addon_aws_ebs_csi_driver_enabled = true
  addon_metrics_server_enabled = true
  addon_cluster_autoscaler_enabled = true
  addon_cert_manager_enabled = true
  addon_ingress_aws_enabled = true
  addon_ingress_nginx_enabled = true
  addon_eck_operator_enabled = true
  # Kubernetes tools
  prometheus_ui_enabled = false
  prometheus_host_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  prometheus_path = "/prometheus"
  grafana_ui_enabled = true
  grafana_host_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  grafana_path = "/grafana"
  kibana_ui_enabled = true
  kibana_host_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  kibana_path = "/kibana"
  jaeger_ui_enabled = true
  jaeger_host_name = "${local.common_name}-dev.k8s.cloudtrain.aws.msgoat.eu"
  jaeger_path = "/jaeger"
}
