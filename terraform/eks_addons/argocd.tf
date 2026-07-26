resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    templatefile("${path.module}/argocd.yaml.tpl", {
      acm_certificate_arn = var.acm_certificate_arn
      my_ip               = var.my_ip_cidr
    })
  ]
  wait    = true
  timeout = 600

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}
