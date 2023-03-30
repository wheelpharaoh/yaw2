data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.service_image}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = local.owners
}


resource "aws_launch_template" "this" {
  name = "${local.prefix}-${var.service_version}--${var.branch}-${var.created_at}"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = var.encrypted
    }
  }
  ebs_optimized = var.ebs_optimized

  disable_api_stop        = false
  disable_api_termination = false

  image_id      = data.aws_ami.this.id
  instance_type = var.instance_type


  key_name = var.key_name
  #user_data        = filebase64("${path.module}/tmpl/userdata_${var.branch}.sh.tftpl")
  user_data_base64 = base64encode(var.userdata)


  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    description                 = "${local.prefix}-${var.branch}-ENI"
    security_groups = [
      aws_security_group.this.id,
    ]
  }

  placement {
    availability_zone = var.availability_zones[0]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        prometheus    = true
        node_exporter = true
      },
      local.tags
    )
  }

}
