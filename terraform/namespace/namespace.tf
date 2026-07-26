resource "kubernetes_namespace" "this" {
  for_each = var.namespaces

  metadata {
    name = each.key

    labels = {
      app         = each.value.app
      environment = each.value.environment
    }
  }
}
