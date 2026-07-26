resource "helm_release" "promtail" {
  name             = "promtail"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"

  values = [
    templatefile("${path.module}/promtail.yaml.tpl", {
      loki_url = var.loki_url
    })
  ]

  depends_on = [
    helm_release.loki,
    helm_release.aws_load_balancer_controller
  ]
}
