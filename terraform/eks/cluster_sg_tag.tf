resource "aws_ec2_tag" "cluster_sg_karpenter_discovery" {
  for_each = aws_eks_cluster.this

  resource_id = each.value.vpc_config[0].cluster_security_group_id
  key         = "karpenter.sh/discovery"
  value       = each.value.name
}
