resource "helm_release" "loki" {
  name             = "loki"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"

  values = [
    templatefile(
      "${path.module}/loki.yaml.tpl", {
        loki_storage_size = var.loki_storage_size
        loki_replicas     = var.loki_replicas
        loki_bucket_name  = var.loki_s3_name
        loki_role_arn     = var.loki_role_arn
    })
  ]

  timeout         = 600
  wait            = true
  cleanup_on_fail = true

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}
