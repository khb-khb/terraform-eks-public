variable "security_groups" {
  type = map(object({
    tags = map(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "security_group_ingress_rules" {
  type = map(object({
    type       = string
    from_port  = number
    to_port    = number
    protocol   = string
    sg_id_key  = string
    src_sg_key = string
  }))
}

variable "security_group_egress_rules" {
  type = map(object({
    type       = string
    from_port  = number
    to_port    = number
    protocol   = number
    sg_id_key  = string
    cidr_block = list(string)
  }))
}
