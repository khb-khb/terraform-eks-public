resource "kubernetes_limit_range" "this" {
  for_each = var.limit_ranges

  metadata {
    name      = "${each.key}-limitrange"
    namespace = kubernetes_namespace.this[each.key].metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = each.value.default_cpu
        memory = each.value.default_memory
      }

      default_request = {
        cpu    = each.value.request_cpu
        memory = each.value.request_memory
      }
    }
  }
}
