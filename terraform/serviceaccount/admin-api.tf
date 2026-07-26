resource "kubernetes_service_account" "admin_api_sa" {
  metadata {
    name      = "admin-api-sa"
    namespace = "admin-api"

    annotations = {
      "eks.amazonaws.com/role-arn" = var.admin_api_irsa_role_arn
    }
  }
}
