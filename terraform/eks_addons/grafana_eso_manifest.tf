resource "kubectl_manifest" "grafana_admin_secret" {
  yaml_body = templatefile(
    "${path.module}/grafana_eso.yaml.tpl",
    {
      namespace = kubernetes_namespace.monitoring.metadata[0].name
    }
  )

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.external_secrets
  ]
}
