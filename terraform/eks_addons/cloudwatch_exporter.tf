resource "helm_release" "cloudwatch_exporter" {
  name       = "cloudwatch-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-cloudwatch-exporter"
  namespace  = "monitoring"

  values = [
    templatefile("${path.module}/cloudwatch_exporter.yaml.tpl", {
      region   = var.aws_region
      role_arn = var.cloudwatch_exporter_arn
    })
  ]

  wait    = true
  timeout = 600

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
