# IRSA 생성를 적용하기 위해 OIDC Provider 구성
# Pod 단위 최소 권한 접근 구조 구현
# ALB 생성, S3 접근 등을 위함
data "tls_certificate" "eks" {
  for_each = aws_eks_cluster.this

  url = each.value.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  for_each = aws_eks_cluster.this

  url = each.value.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks[each.key].certificates[0].sha1_fingerprint
  ]
}
