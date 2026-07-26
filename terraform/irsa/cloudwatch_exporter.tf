data "aws_iam_policy_document" "cloudwatch_exporter_assume_role" {
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
      values   = ["system:serviceaccount:monitoring:cloudwatch-exporter"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudwatch_exporter_role" {
  name               = var.cloudwatch_exporter_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_exporter_assume_role.json
}

data "aws_iam_policy_document" "cloudwatch_exporter_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "tag:GetResources"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_exporter_policy" {
  name   = var.cloudwatch_exporter_policy_name
  policy = data.aws_iam_policy_document.cloudwatch_exporter_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_exporter_policy" {
  role       = aws_iam_role.cloudwatch_exporter_role.name
  policy_arn = aws_iam_policy.cloudwatch_exporter_policy.arn
}
