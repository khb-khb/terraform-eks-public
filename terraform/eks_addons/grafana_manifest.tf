
resource "kubectl_manifest" "grafana_cloudwatch_exporter_service_monitor" {
  yaml_body = templatefile(
    "${path.module}/grafana_cloudwatch_exporter_service.yaml.tpl",
    {

    }
  )
  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.cloudwatch_exporter
  ]
}
