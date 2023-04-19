generate "common_providers" {
  path      = "common_providers.tf"
  if_exists = "terragrunt_overwrite"
  contents = <<EOF
provider "aws" {
  region = var.region_name
}
EOF
}
