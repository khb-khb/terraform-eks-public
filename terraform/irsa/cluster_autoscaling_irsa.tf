# karpenter 로 대체

# data "aws_iam_policy_document" "cluster_autoscaler_assume_role" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "sts:AssumeRoleWithWebIdentity"
#     ]

#     principals {
#       type        = "Federated"
#       identifiers = [var.oidc_provider_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${var.oidc_provider_url}:sub"

#       values = [
#         "system:serviceaccount:kube-system:cluster-autoscaler"
#       ]
#     }
#   }
# }

# resource "aws_iam_role" "cluster_autoscaler_role" {
#   name = var.cluster_autoscaler_role_name

#   assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role.json
# }

# data "aws_iam_policy_document" "cluster_autoscaler_policy_document" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeScalingActivities",
#       "autoscaling:DescribeTags",
#       "ec2:DescribeInstanceTypes",
#       "ec2:DescribeLaunchTemplateVersions",
#       "eks:DescribeNodegroup"
#     ]

#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup"
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "cluster_autoscaler_policy" {
#   name   = var.cluster_autoscaler_policy_name
#   policy = data.aws_iam_policy_document.cluster_autoscaler_policy_document.json
# }

# resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy" {
#   role       = aws_iam_role.cluster_autoscaler_role.name
#   policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
# }
