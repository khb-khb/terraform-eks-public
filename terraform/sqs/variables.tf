variable "queue_name" {
  type = string
}

variable "dlq_name" {
  type = string
}

variable "visibility_timeout_seconds" {
  type = number
}

variable "message_retention_seconds" {
  type = number
}

variable "dlq_message_retention_seconds" {
  type = number
}

variable "max_receive_count" {
  type = number
}

variable "tags" {
  type = map(string)
}
