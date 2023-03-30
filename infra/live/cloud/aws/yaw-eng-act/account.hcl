# Set (AWS) account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "yaw"
  aws_account_id = "000000000000"
  aws_profile    = "terraform"

  key_name = "yaw"
}
