variable "alb_controller_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

# karpenter 로 대체
# variable "cluster_autoscaler_role_arn" {
#   type = string
# }


variable "external_dns_role_arn" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "github_app_id" {
  type = string
}

variable "github_app_installation_id" {
  type = string
}

variable "github_app_private_key_name" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "eso_role_arn" {
  type = string
}

variable "argocd_repo_name" {
  type = string
}

variable "my_ip_cidr" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "karpenter_controller_role_arn" {
  type = string
}

variable "karpenter_node_role_name" {
  type = string
}

variable "api_namespace" {
  type = string
}

variable "default_workload" {
  type = string
}

variable "pii_workload" {
  type = string
}

variable "default_name" {
  type = string
}

variable "pii_name" {
  type = string
}

variable "loki_storage_size" {
  type = string
}

variable "loki_replicas" {
  type = number
}

variable "loki_url" {
  type = string
}

variable "loki_s3_name" {
  type = string
}

variable "loki_role_arn" {
  type = string
}

variable "keda_irsa_role_arn" {
  type = string
}

variable "cloudwatch_exporter_arn" {
  type = string
}
