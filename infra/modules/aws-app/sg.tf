resource "random_id" "rnd" {
  byte_length = 2
}

resource "aws_security_group" "svc" {
  name        = "${local.prefix}-svc-sg-${random_id.rnd.hex}"
  description = "${var.service_name} service traffic"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = var.service_port
    to_port         = var.service_port
    protocol        = "tcp"
    description     = "${var.service_name}-lb"
    security_groups = [aws_security_group.lb.id]
    cidr_blocks     = var.ingress_cidrs
  }

  ingress {
    description = "Open to self"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "lb" {
  name        = "${local.prefix}-lb-sg-${random_id.rnd.hex}"
  description = "${var.service_name} lb traffic"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "proxy-http"
    cidr_blocks = var.ingress_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "proxy-https"
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    description = "Allow outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "node_exporter" {
  name        = "${local.prefix}-node_exporter-sg-${random_id.rnd.hex}"
  description = "${var.service_name} node_exporter traffic"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    description = "node_exporter metrics"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

