# monitoring_alert_chatbot role
data "aws_iam_policy_document" "chatbot_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "monitoring_chatbot_service_role" {
  name               = var.monitoring_chatbot_role_name
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume_role.json

  tags = {
    Name = var.monitoring_chatbot_role_name
  }
}

resource "aws_iam_role_policy_attachment" "chatbot_cloudwatch_readonly" {
  role       = aws_iam_role.monitoring_chatbot_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "chatbot_logs_readonly" {
  role       = aws_iam_role.monitoring_chatbot_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}
