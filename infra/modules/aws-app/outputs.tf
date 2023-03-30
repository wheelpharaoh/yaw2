output "createdAt" {
  value = var.created_at
}

# instance-profile
output "instance_profile_name" {
  value = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.this.arn
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.this.id
}

output "instance_profile_instance_profile_role" {
  value = aws_iam_instance_profile.this.role
}


# launch-template
output "lt_arn" {
  value = aws_launch_template.this.arn
}

output "lt_default_version" {
  value = aws_launch_template.this.default_version
}

output "lt_id" {
  value = aws_launch_template.this.id
}

output "lt_image_id" {
  value = aws_launch_template.this.image_id
}

output "lt_iam_instance_profile" {
  value = aws_launch_template.this.iam_instance_profile
}

output "lt_latest_version" {
  value = aws_launch_template.this.latest_version
}

output "lt_name" {
  value = aws_launch_template.this.name
}


# autoscaling-group
output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}

output "asg_availability_zones" {
  value = aws_autoscaling_group.this.availability_zones
}

output "asg_target_group_arns" {
  value = aws_autoscaling_group.this.target_group_arns
}

output "asg_id" {
  value = aws_autoscaling_group.this.id
}

output "asg_launch_configuration" {
  value = aws_autoscaling_group.this.launch_configuration
}

output "asg_desired_capacity" {
  value = aws_autoscaling_group.this.desired_capacity
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}

