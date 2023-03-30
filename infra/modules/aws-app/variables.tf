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

variable "service_image" {
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
variable "key_name" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}


variable "instance_type" {
  type    = string
  default = "t2.xlarge"
}

variable "volume_size" {
  type    = string
  default = "30"
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "ebs_optimized" {
  type    = bool
  default = true
}

variable "encrypted" {
  type    = bool
  default = true
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 10
}

variable "desired_capacity" {
  type    = number
  default = 1
}
variable "vpc_zone_identifier" {
  type = list(string)
}
variable "vpc_cidr_block" {
  type = string

}



variable "user_data" {
  type = string
}

