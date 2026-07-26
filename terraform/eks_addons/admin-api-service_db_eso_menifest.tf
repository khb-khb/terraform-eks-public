resource "kubectl_manifest" "admin_api_db_secret" {
  yaml_body = templatefile(
    "${path.module}/admin-api-service_db_eso.yaml.tpl",
    {
      namespace = var.api_namespace
    }
  )

  depends_on = [
    helm_release.external_secrets
  ]
}
