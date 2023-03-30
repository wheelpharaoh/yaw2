locals {
  git_repo = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.git_repo

  created_at = formatdate("YYYYMMDD", timestamp())

  service_version = "latest"
  service_name    = "yaw"
}

terraform {
  source = "${get_repo_root()}/infra/modules/aws-app///"
  #source = "git@github.com:wheelpharaoh/yaw2.git//infra/modules/aws-app?ref=${branch}"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  # tags
  created_at      = local.created_at
  service_name    = local.service_name
  service_version = local.service_version
  # aws
  service_image    = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  min_size         = 0
  max_size         = 10
  desired_capacity = 1
  instance_type    = "r5a.large"
  volume_size      = 64
}
