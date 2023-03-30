
output "generic_endpoint_policy_json" {

  value = data.aws_iam_policy_document.generic_endpoint_policy.json
}

output "dynamodb_endpoint_policy_json" {

  value = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
}
