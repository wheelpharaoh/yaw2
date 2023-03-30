output "sg_vpc_base" {
  description = "sg web+dns traffic"
  value       = aws_security_group.vpc_base.id
}

output "sg_vpc_remote" {
  description = "sg ssh rdp traffic"
  value       = aws_security_group.vpc_remote.id
}
