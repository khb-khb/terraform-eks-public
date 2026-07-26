data "aws_iam_policy_document" "keda_consumer_assume_role" {
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
      values = [
        "system:serviceaccount:keda-consumer:keda-consumer",
      "system:serviceaccount:keda-cron:keda-consumer"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "keda_consumer_role" {
  name               = "keda-consumer-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.keda_consumer_assume_role.json
}

data "aws_iam_policy_document" "keda_consumer_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility"
    ]

    resources = [
      var.sqs_keda_queue_arn
    ]
  }
}

resource "aws_iam_policy" "keda_consumer_policy" {
  name   = "keda-consumer-policy"
  policy = data.aws_iam_policy_document.keda_consumer_policy_document.json
}

resource "aws_iam_role_policy_attachment" "keda_consumer_policy" {
  role       = aws_iam_role.keda_consumer_role.name
  policy_arn = aws_iam_policy.keda_consumer_policy.arn
}
