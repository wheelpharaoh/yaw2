locals {
  created_at = formatdate("YYYYMMDD", timestamp())
  git_repo   = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.git_repo


  service_version = "v1"
  service_name    = "dev-network"
}

terraform {
  source = "${get_repo_root()}/infra/modules/aws-network-endpoints///"
  #source = "git@github.com:wheelpharaoh/yaw2.git//infra/modules/aws-network-endpoints?ref=${branch}"
}

include "root" {
  path = find_in_parent_folders()
}


dependency "sg" {
  config_path = "../sg"
}

dependency "policy" {
  config_path = "../policy"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  created_at         = local.created_at
  service_name       = local.service_name
  service_version    = local.service_version
  vpc_id             = dependency.vpc.outputs.vpc_id
  security_group_ids = [dependency.sg.outputs.sg_vpc_base]

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([dependency.vpc.outputs.intra_route_table_ids, dependency.vpc.outputs.private_route_table_ids, dependency.vpc.outputs.public_route_table_ids])
      policy          = dependency.policy.outputs.dynamodb_endpoint_policy_json
      tags            = { Name = "dynamodb-vpc-endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.sg_vpc_base]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    lambda = {
      service             = "lambda"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    ecs = {
      create              = false
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    ecs_telemetry = {
      create              = false
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.sg_vpc_base]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      policy              = dependency.policy.outputs.generic_endpoint_policy_json
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      policy              = dependency.policy.outputs.generic_endpoint_policy_json
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.sg_vpc_base]
    },
    codedeploy = {
      service             = "codedeploy"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
    codedeploy_commands_secure = {
      service             = "codedeploy-commands-secure"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
    },
  }

  #tags = merge(local.tags, {
  #Project  = "Secret"
  #Endpoint = "true"
  #})

}
