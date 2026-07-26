
variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "alb_controller_policy_name" {
  type = string
}

variable "alb_controller_role_name" {
  type = string
}

variable "external_dns_role_name" {
  type = string
}

variable "external_dns_policy_name" {
  type = string
}

variable "eso_policy_name" {
  type = string
}

variable "eso_role_name" {
  type = string
}

variable "secretsmanager_github_app_private_key_arn" {
  type = string
}

variable "secretsmanager_grafana_admin_arn" {
  type = string
}

variable "secretsmanager_admin_db_arn" {
  type = string
}

variable "loki_s3_arn" {
  type = string
}

variable "keda_role_name" {
  type = string
}

variable "sqs_keda_queue_arn" {
  type = string
}

variable "keda_policy_name" {
  type = string
}

variable "cloudwatch_exporter_role_name" {
  type = string
}

variable "cloudwatch_exporter_policy_name" {
  type = string
}
