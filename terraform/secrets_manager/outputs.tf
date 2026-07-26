# output "github_app_private_key" {
#   value     = data.aws_secretsmanager_secret_version.github_app_private_key.secret_string
#   sensitive = true
# }

output "github_app_private_key_arn" {
  value = data.aws_secretsmanager_secret.github_app.arn
}

output "github_app_private_key_name" {
  value = data.aws_secretsmanager_secret.github_app.name
}

output "admin_db_arn" {
  value = data.aws_secretsmanager_secret.admin_db.arn
}

output "admin_db_name" {
  value = data.aws_secretsmanager_secret.admin_db.name
}

output "grafana_admin_arn" {
  value = data.aws_secretsmanager_secret.grafana_admin.arn
}

output "grafana_admin_name" {
  value = data.aws_secretsmanager_secret.grafana_admin.name
}
