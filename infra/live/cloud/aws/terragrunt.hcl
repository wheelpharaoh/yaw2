# ---------------------------------------------------------------------------------------------------------------------
# local vars
# ---------------------------------------------------------------------------------------------------------------------
locals {
  tg_version     = "0.38.12"
  tf_version     = "1.3.1"
  aws_version    = "4.40.0"
  backend_bucket = "yaw-shared-cloud-aws-tf-tfstate"
  ddb_table      = "yaw-shared-cloud-aws-lock-tbl"

  # Automatically load account-level variables
  account_vars = try(read_terragrunt_config(find_in_parent_folders("account.hcl")), null)

  # Automatically load region-level variables
  region_vars = try(read_terragrunt_config(find_in_parent_folders("region.hcl")), null)

  # Automatically load environment-level variables
  environment_vars = try(read_terragrunt_config(find_in_parent_folders("env.hcl")), null)

  # Automatically load environment-level variables
  az_vars = try(read_terragrunt_config(find_in_parent_folders("az.hcl")), null)

  # Extract the variables we need for easy access
  account_name = try(local.account_vars.locals.account_name, null)
  account_id   = try(local.account_vars.locals.aws_account_id, null)
  aws_region   = try(local.region_vars.locals.aws_region, "us-west-1")
}


# ---------------------------------------------------------------------------------------------------------------------
# pinning
# ---------------------------------------------------------------------------------------------------------------------
terragrunt_version_constraint = ">= ${local.tg_version}"
terraform_version_constraint  = ">= ${local.tf_version}"


# ---------------------------------------------------------------------------------------------------------------------
# global vars
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  { "tg_version" = replace(local.tg_version, ".", "") },
  { "tf_version" = replace(local.tf_version, ".", "") },
  try(local.account_vars.locals, null),
  try(local.region_vars.locals, null),
  try(local.environment_vars.locals, null),
  try(local.az_vars.locals, null),
)


# ---------------------------------------------------------------------------------------------------------------------
# backend.tf
# ---------------------------------------------------------------------------------------------------------------------
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "${local.backend_bucket}"
    key            = "${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "${local.ddb_table}"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# provider.tf
# ---------------------------------------------------------------------------------------------------------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  default_tags {
    tags = {
      terraform  = "${local.tf_version}"
      terragrunt = "${local.tg_version}"
    }
  }
}
EOF
}


# ---------------------------------------------------------------------------------------------------------------------
# versions.tf
# ---------------------------------------------------------------------------------------------------------------------
generate "versions" {
  path = "versions.tf"

  if_exists = "overwrite"

  contents = <<EOF
terraform {
  required_version = "${local.tf_version}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.aws_version}"
    }
  }
}
EOF
}
