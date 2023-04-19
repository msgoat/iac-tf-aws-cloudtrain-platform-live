generate "providers" {
  path      = "common_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = var.region_name
}
EOF
}
