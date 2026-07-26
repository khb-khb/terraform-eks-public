output "oidc_provider_arn" {
  value = {
    for key, provider in aws_iam_openid_connect_provider.eks :
    key => provider.arn
  }
}

output "oidc_provider_url" {
  value = {
    for key, provider in aws_iam_openid_connect_provider.eks :
    key => provider.url
  }
}

output "oidc_provider_url_https_del" {
  value = {
    for key, provider in aws_iam_openid_connect_provider.eks :
    key => replace(provider.url, "https://", "")
  }
}

output "cluster_name" {
  value = {
    for key, cluster in aws_eks_cluster.this :
    key => cluster.name
  }
}

output "cluster_endpoint" {
  value = {
    for key, cluster in aws_eks_cluster.this :
    key => cluster.endpoint
  }
}

output "cluster_ca" {
  value = {
    for key, cluster in aws_eks_cluster.this :
    key => cluster.certificate_authority[0].data
  }
}

output "cluster_security_group_ids" {
  value = {
    for key, cluster in aws_eks_cluster.this :
    key => cluster.vpc_config[0].cluster_security_group_id
  }
}
