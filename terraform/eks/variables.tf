variable "eks_cluster" {
  type = map(object({
    cluster_name       = string
    cluster_role_arn   = string
    version            = string
    cluster_subnet_ids = list(string)
  }))
}

variable "eks_node_group" {
  type = map(object({
    cluster_key      = string
    node_group_name  = string
    node_role_arn    = string
    node_subnet_ids  = list(string)
    instance_types   = list(string)
    capacity_type    = string
    nodegroup_labels = string
    desired_size     = number
    min_size         = number
    max_size         = number
  }))
}

variable "eks_access_entries" {
  type = map(object({
    principal_arn = string
    policy_arn    = string
    access_scope  = string
  }))
}

variable "cluster_name" {
  type = string
}

variable "karpenter_node_role_arn" {
  type = string
}
