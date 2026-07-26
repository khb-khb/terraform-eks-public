# Kubernetes 가 AWS ALB 를 자동 생성/관리 하기 위함
# AWS Loadbalance controller 를 사용
# AWS IAM 쪽 설정. EKS ServiceAccount 가 사용할 IAM Role(IRSA) 정의
# AWS 가 어떤 ServiceAccount  를 신뢰할지 설정
data "aws_iam_policy_document" "alb_controller_assume_role_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  name = var.alb_controller_policy_name

  policy = file("${path.module}/iam_policy.json")
}

resource "aws_iam_role" "alb_controller_role" {
  name               = var.alb_controller_role_name
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_document.json
}


resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
