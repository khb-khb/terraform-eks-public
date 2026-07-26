data "aws_secretsmanager_secret" "github_app" {
  name = "github-app-private-key"
}

# data "aws_secretsmanager_secret_version" "github_app_private_key" {
#   secret_id = data.aws_secretsmanager_secret.github_app.id
# }

data "aws_secretsmanager_secret" "admin_db" {
  name = "admin-db"
}

data "aws_secretsmanager_secret" "grafana_admin" {
  name = "grafana-admin"
}
