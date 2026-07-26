output "queue_name" {
  value = aws_sqs_queue.keda_sqs.name
}

output "queue_url" {
  value = aws_sqs_queue.keda_sqs.url
}

output "queue_arn" {
  value = aws_sqs_queue.keda_sqs.arn
}

output "dlq_name" {
  value = aws_sqs_queue.keda_dlq.name
}

output "dlq_url" {
  value = aws_sqs_queue.keda_dlq.url
}

output "dlq_arn" {
  value = aws_sqs_queue.keda_dlq.arn
}
