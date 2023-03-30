locals {
  created_at = formatdate("YYYYMMDD", timestamp())
  git_repo   = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.git_repo

  service_version = "v1"
  service_name    = "dev-network"
}

terraform {
  source = "${get_repo_root()}/infra/modules/aws-network-fw///"
  #source = "git@github.com:wheelpharaoh/yaw2.git//infra/modules/aws-network-fw?ref=${branch}"
}

include "root" {
  path = find_in_parent_folders()
}


inputs = {
  # tags
  created_at      = local.created_at
  service_name    = local.service_name
  service_version = local.service_version

}
