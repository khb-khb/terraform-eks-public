variable "cluster_name" {
  type = string
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}
