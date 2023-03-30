locals {
  tags = merge(
    var.additional_tags,
    {
      Name    = var.service_name
      env     = var.env
      region  = var.region
      branch  = var.branch
      service = var.service_name
      version = var.service_version
    }
  )

  createdAt    = var.created_at
  short_region = join("", [for s in split("-", "${var.region}") : substr(s, 0, 1)])
  prefix       = "${var.env}-${local.short_region}-${var.service_name}"

  owners = [
    "amazon",
    "self",
    var.aws_account_id,
  ]
}

resource "aws_route53_record" "default" {
  count = length(var.subdomains)

  zone_id = var.zone_id
  name    = var.subdomains[count.index]
  type    = "A"
  alias {
    name                   = aws_lb.default.dns_name
    zone_id                = aws_lb.default.zone_id
    evaluate_target_health = false
  }
}
