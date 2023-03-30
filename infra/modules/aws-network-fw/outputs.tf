output "network_firewall_arn" {
  description = "ARN of the Network Firewall"
  value       = aws_networkfirewall_firewall_policy.this.arn
}

output "drop_icmp_rg" {
  description = "ping rule group"
  value       = aws_networkfirewall_rule_group.drop_icmp.arn
}

output "drop_dns_pub_rg" {
  description = "dns public resolver rule group"
  value       = aws_networkfirewall_rule_group.drop_dns_pub.arn
}
