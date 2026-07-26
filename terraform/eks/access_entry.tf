# IAM 사용자에 대해 EKS 접근 권한 구성
# eks 권한 추후에 iam 계정별 권한 지정
resource "aws_eks_access_entry" "this" {
  for_each = var.eks_access_entries

  cluster_name  = var.cluster_name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_access_policy_association" "this" {
  for_each = var.eks_access_entries

  cluster_name  = var.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type = each.value.access_scope
  }

  depends_on = [
    aws_eks_access_entry.this
  ]
}

resource "aws_eks_access_entry" "karpenter_node" {
  cluster_name  = var.cluster_name
  principal_arn = var.karpenter_node_role_arn
  type          = "EC2_LINUX"

  depends_on = [
    aws_eks_cluster.this
  ]
}
