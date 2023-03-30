locals {
  created_at = formatdate("YYYYMMDD", timestamp())
  git_repo   = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.git_repo
  branch     = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.branch
  region     = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region

  service_version = "v2"
  service_name    = "dev-network"
}

terraform {
  source = "${get_repo_root()}/infra/modules/aws-network-vpc///"
  #source = "git@github.com:wheelpharaoh/yaw2.git//infra/modules/aws-network-vpc?ref=${branch}"
}

include "root" {
  path = find_in_parent_folders()
}
dependency "fw" {
  config_path = "../fw"
}

inputs = {
  # tags
  created_at      = local.created_at
  service_name    = local.service_name
  service_version = local.service_version

  ################################################################################
  # VPC Module
  ################################################################################

  cidr = "10.0.0.0/16"
  #secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"] # extendable

  name = "${local.service_name}-${local.service_version}-${local.branch}"
  #azs  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  #public_subnets      = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  #intra_subnets       = ["10.0.24.0/21", "10.0.32.0/21", "10.0.40.0/21"]
  #private_subnets     = ["10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21"]
  #database_subnets    = ["10.0.72.0/21", "10.0.80.0/21", "10.0.88.0/21"]
  #elasticache_subnets = ["10.0.96.0/21", "10.0.104.0/21", "10.0.112.0/21"]
  #redshift_subnets    = ["10.0.120.0/21", "10.0.128.0/21", "10.0.136.0/21"]
  #firewall_subnets    = ["10.0.144.0/21", "10.0.152.0/21", "10.0.160.0/21"]

  azs                 = ["${local.region}a", "${local.region}c"]
  public_subnets      = ["10.0.0.0/21", "10.0.16.0/21"]
  intra_subnets       = ["10.0.24.0/21", "10.0.40.0/21"]
  private_subnets     = ["10.0.48.0/21", "10.0.64.0/21"]
  database_subnets    = ["10.0.72.0/21", "10.0.88.0/21"]
  elasticache_subnets = ["10.0.96.0/21", "10.0.112.0/21"]
  redshift_subnets    = ["10.0.120.0/21", "10.0.136.0/21"]
  firewall_subnets    = ["10.0.144.0/21", "10.0.160.0/21"]

  # NAT
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  single_nat_gateway     = false

  # routes
  create_database_subnet_route_table    = false
  create_elasticache_subnet_route_table = false
  create_redshift_subnet_route_table    = false

  # Nacls
  public_dedicated_network_acl      = false
  private_dedicated_network_acl     = false
  database_dedicated_network_acl    = false
  elasticache_dedicated_network_acl = false
  redshift_dedicated_network_acl    = false

  # Nfirewall
  enable_firewall      = false
  enable_firewall_logs = false
  firewall_log_types = [
    "FLOW",
    "ALERT"
  ]
  firewall_policy_arn = dependency.fw.outputs.network_firewall_arn

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_dhcp_options  = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # VPN
  enable_vpn_gateway = false

  # logging
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60
}
