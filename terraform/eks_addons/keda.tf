resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = "keda"
  create_namespace = true

  values = [
    templatefile("${path.module}/keda.yaml.tpl", {
      keda_irsa_role_arn = var.keda_irsa_role_arn
    })
  ]

  wait            = true
  timeout         = 600
  cleanup_on_fail = true
  force_update    = true

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
