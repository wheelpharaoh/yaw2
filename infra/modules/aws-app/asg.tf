resource "aws_autoscaling_policy" "this_up" {
  name                   = "${local.prefix}-${var.gh_repo}-${var.branch}-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "this_up" {
  alarm_name          = "${local.prefix}-${var.gh_repo}-${var.branch}-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "This metric monitors EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.this_up.arn]

  tags = local.tags
}

resource "aws_autoscaling_policy" "this_down" {
  name                   = "${local.prefix}-${var.gh_repo}-${var.branch}-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "this_down" {
  alarm_name          = "${local.prefix}-${var.gh_repo}-${var.branch}-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "This metric monitors EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.this_down.arn]

  tags = local.tags
}


# skip
resource "aws_autoscaling_group" "this" {
  name = "${local.prefix}-${var.gh_repo}-${var.branch}-asg"
  launch_template {
    id      = resource.aws_launch_template.this.id
    version = resource.aws_launch_template.this.latest_version
  }
  force_delete = true
  min_size     = var.min_size
  max_size     = var.max_size
  #availability_zones = var.availability_zones
  desired_capacity = var.desired_capacity

  #vpc_zone_identifier = [for x in values(aws_subnet.this)[*].id : x]
  vpc_zone_identifier = var.vpc_zone_identifier

  initial_lifecycle_hook {
    name                 = "${var.service_name}-startup-lch"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 75
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_metadata = jsonencode(
      {
        "region"          = var.aws_region
        "branch"          = var.branch
        "short_region"    = local.short_region
        "env"             = var.environment
        "service"         = var.service_name
        "gh_owner"        = var.gh_owner
        "gh_repo"         = var.gh_repo
        "app_id"          = var.app_id
        "installation_id" = var.installation_id
        "do"              = "register"
      }
    )
  }
  initial_lifecycle_hook {
    name                 = "${var.service_name}-terminate-lch"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 60
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    notification_metadata = jsonencode(
      {
        "region"          = var.aws_region
        "branch"          = var.branch
        "short_region"    = local.short_region
        "env"             = var.environment
        "service"         = var.service_name
        "gh_owner"        = var.gh_owner
        "gh_repo"         = var.gh_repo
        "app_id"          = var.app_id
        "installation_id" = var.installation_id
        "do"              = "remove"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, max_size, min_size, tag]
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}
