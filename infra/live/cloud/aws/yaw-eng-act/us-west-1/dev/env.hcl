# Set (AWS) environment-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  environment = "dev"
  branch      = "main"
  git_repo    = "git::git@github.com:wheelpharaoh/yaw2.git"
  key_name    = "yaw"
}
