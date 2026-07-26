resource "aws_eks_node_group" "this" {
  for_each = var.eks_node_group

  cluster_name    = aws_eks_cluster.this[each.value.cluster_key].name
  node_group_name = each.value.node_group_name
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.node_subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  labels = {
    nodegroup = each.value.nodegroup_labels
  }
  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  depends_on = [
    aws_eks_cluster.this
  ]

  tags = {
    Name = each.value.node_group_name

    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }
}
