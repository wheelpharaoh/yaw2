# Set (AWS) region-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  aws_region         = "us-west-1"
  availability_zones = ["us-west-1a", "us-west-1c"]
}
