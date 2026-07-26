variable "eks_cluster_role_name" {
  type = string
}

variable "eks_node_role_name" {
  type = string
}

variable "monitoring_chatbot_role_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "karpenter_controller_policy_name" {
  type = string
}

variable "karpenter_node_role_name" {
  type = string
}

variable "karpenter_node_instance_profile_name" {
  type = string
}

variable "karpenter_controller_role_name" {
  type = string
}
