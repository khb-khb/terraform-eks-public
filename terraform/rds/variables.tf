variable "db_subnet_groups" {
  type = map(object({
    name       = string
    subnet_ids = list(string)
  }))
}

variable "db_clusters" {
  type = map(object({
    cluster_identifier      = string
    engine                  = string
    engine_version          = string
    database_name           = string
    master_username         = string
    db_subnet_group_key     = string
    vpc_security_group_ids  = list(string)
    port                    = number
    backup_retention_period = number
    skip_final_snapshot     = bool
  }))
}

variable "db_instances" {
  type = map(object({
    instance_class = string
    cluster_key    = string
  }))
}

