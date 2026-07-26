data "aws_iam_policy_document" "keda_assume_role" {
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
      values   = ["system:serviceaccount:keda:keda-operator"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "keda_role" {
  name               = var.keda_role_name
  assume_role_policy = data.aws_iam_policy_document.keda_assume_role.json
}

data "aws_iam_policy_document" "keda_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]

    resources = [
      var.sqs_keda_queue_arn
    ]
  }
}

resource "aws_iam_policy" "keda_policy" {
  name   = var.keda_policy_name
  policy = data.aws_iam_policy_document.keda_policy_document.json
}

resource "aws_iam_role_policy_attachment" "keda_policy" {
  role       = aws_iam_role.keda_role.name
  policy_arn = aws_iam_policy.keda_policy.arn
}
