resource "aws_sqs_queue" "keda_dlq" {
  name = var.dlq_name

  message_retention_seconds = var.dlq_message_retention_seconds

  tags = var.tags
}

resource "aws_sqs_queue" "keda_sqs" {
  name = var.queue_name

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.keda_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = var.tags
}
