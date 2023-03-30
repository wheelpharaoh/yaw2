#
# Meta
#
variable "branch" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_version" {
  type = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "created_at" {
  type = string
}

#
# cloud
#
variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "aws_account_id" {
  type = string
}
#
# module
# 

variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "vpc_cidr_blocks" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = list(string)
  default     = null
}
variable "intra_subnets_cidr_blocks" {
  description = "intra_subnets_cidr_blocks"
  type        = list(string)
  default     = null
}
