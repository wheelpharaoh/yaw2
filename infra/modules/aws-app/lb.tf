resource "aws_eip" "lb" {
  vpc = true
}


resource "aws_lb" "this" {
  name               = "${local.prefix}-lb"
  internal           = false
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = [var.subnets[0]]
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.lb.id
    }
  }

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}


resource "aws_lb_target_group" "this" {
  name     = "${local.prefix}-lb-tg"
  port     = var.service_port
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/api/health"
    port                = var.service_port
    interval            = 30
  }

}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.default.arn
  port              = var.lb_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

