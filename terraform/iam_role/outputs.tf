output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "monitoring_chatbot_role_arn" {
  value = aws_iam_role.monitoring_chatbot_service_role.arn
}

output "karpenter_node_role_name" {
  value = aws_iam_role.karpenter_node_role.name
}

output "karpenter_node_role_arn" {
  value = aws_iam_role.karpenter_node_role.arn
}
