resource "aws_security_group" "vpc_remote" {
  name_prefix = "${var.service_name}-vpc_remote"
  description = "Allow ssh rdp inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH in VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.intra_subnets_cidr_blocks
  }

  ingress {
    description = "RDP in VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.intra_subnets_cidr_blocks
  }

  tags = local.tags
}


