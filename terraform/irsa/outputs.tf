output "karpenter_controller_role_name" {
  value = aws_iam_role.karpenter_controller_role.name
}

output "karpenter_controller_role_arn" {
  value = aws_iam_role.karpenter_controller_role.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller_role.arn
}

output "external_dns_role_arn" {
  value = aws_iam_role.external_dns.arn
}

output "external_secrets_role_arn" {
  value = aws_iam_role.eso_role.arn
}

output "loki_s3_role_arn" {
  value = aws_iam_role.loki_role.arn
}

output "keda_role_arn" {
  value = aws_iam_role.keda_role.arn
}

output "cloudwatch_exporter_arn" {
  value = aws_iam_role.cloudwatch_exporter_role.arn
}
