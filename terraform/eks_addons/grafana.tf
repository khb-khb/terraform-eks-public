resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [
    templatefile(
      "${path.module}/grafana.yaml.tpl",
      {
        acm_certificate_arn = var.acm_certificate_arn
        my_ip               = var.my_ip_cidr
      }
    )
  ]

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  depends_on = [
    kubectl_manifest.grafana_admin_secret,
    helm_release.aws_load_balancer_controller
  ]

  wait    = true
  timeout = 600
}
