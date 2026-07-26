data "aws_iam_policy_document" "karpenter_controller_policy_document" {
  statement {
    sid    = "Karpenter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateTags",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "InstanceProfileManagement"
    effect = "Allow"

    actions = [
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ConditionalEC2Termination"
    effect = "Allow"

    actions = [
      "ec2:TerminateInstances"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  statement {
    sid    = "PassNodeIAMRole"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.karpenter_node_role.arn
    ]
  }

  statement {
    sid    = "EKSClusterEndpointLookup"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      "arn:aws:eks:${var.region}:${var.account_id}:cluster/${var.cluster_name}"
    ]
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name   = var.karpenter_controller_policy_name
  policy = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_policy" {
  role       = var.karpenter_controller_role_name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}

resource "aws_iam_role" "karpenter_node_role" {
  name               = var.karpenter_node_role_name
  assume_role_policy = data.aws_iam_policy_document.karpenter_node_assume_role.json
}

data "aws_iam_policy_document" "karpenter_node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_node_worker_node_policy" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "karpenter_node_ecr_policy" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "karpenter_node_cni_policy" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "karpenter_node_ssm_policy" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "karpenter_node_instance_profile" {
  name = var.karpenter_node_instance_profile_name
  role = aws_iam_role.karpenter_node_role.name
}
