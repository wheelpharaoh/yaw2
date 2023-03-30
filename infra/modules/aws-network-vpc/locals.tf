locals {
  tags = merge(
    var.additional_tags,
    {
      Name   = var.service_name
      env    = var.environment
      region = var.aws_region
      branch = var.branch
    }
  )

  createdAt    = var.created_at
  short_region = join("", [for s in split("-", "${var.aws_region}") : substr(s, 0, 1)])
  prefix       = "${var.environment}-${local.short_region}-${var.service_name}"
}
