include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../iac-tf-aws-network-modules//modules/vpc"
}

inputs = {
}
