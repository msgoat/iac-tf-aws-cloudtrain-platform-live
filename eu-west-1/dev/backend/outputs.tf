output backend_tf_file {
  description = "Contents of the backend.tf file to be added to project"
  value = module.backend.terraform_backend_file
}

output terragrunt_remote_state_block {
  description = "Contents of remote_state block to be added to Terragrunt configuration files"
  value = module.backend.terragrunt_remote_state_block
}