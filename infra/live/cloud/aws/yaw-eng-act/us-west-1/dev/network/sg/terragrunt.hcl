locals {
  created_at = formatdate("YYYYMMDD", timestamp())
  git_repo   = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.git_repo


  service_version = "v1"
  service_name    = "dev-network"
}

terraform {
  source = "${get_repo_root()}/infra/modules/aws-network-sg///"
  #source = "git@github.com:wheelpharaoh/yaw2.git//infra/modules/aws-network-sg?ref=${branch}"
}

include "root" {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
}


inputs = {
  # tags
  created_at      = local.created_at
  service_name    = local.service_name
  service_version = local.service_version

  vpc_id                    = dependency.vpc.outputs.vpc_id
  vpc_cidr_blocks           = [dependency.vpc.outputs.vpc_cidr_block]
  intra_subnets_cidr_blocks = dependency.vpc.outputs.intra_subnets_cidr_blocks

}
