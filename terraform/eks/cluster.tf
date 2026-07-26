resource "aws_eks_cluster" "this" {
  for_each = var.eks_cluster

  name     = each.value.cluster_name
  role_arn = each.value.cluster_role_arn
  version  = each.value.version

  vpc_config {
    subnet_ids              = each.value.cluster_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = each.value.cluster_name
  }
}


