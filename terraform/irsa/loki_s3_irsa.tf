data "aws_iam_policy_document" "loki_assume_role_policy" {
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
      values   = ["system:serviceaccount:monitoring:loki"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "loki_role" {
  name               = "loki-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.loki_assume_role_policy.json
}

data "aws_iam_policy_document" "loki_s3_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.loki_s3_arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.loki_s3_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "loki_s3_policy" {
  name   = "loki-s3-policy"
  policy = data.aws_iam_policy_document.loki_s3_policy_document.json
}

resource "aws_iam_role_policy_attachment" "loki_s3_policy_attach" {
  role       = aws_iam_role.loki_role.name
  policy_arn = aws_iam_policy.loki_s3_policy.arn
}
