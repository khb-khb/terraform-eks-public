variable "namespaces" {
  type = map(object({
    app         = string
    environment = string
  }))
}

variable "limit_ranges" {
  type = map(object({
    default_cpu    = string
    default_memory = string
    request_cpu    = string
    request_memory = string
  }))
}
