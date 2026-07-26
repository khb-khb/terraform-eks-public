# karpenter 로 대체

# resource "kubernetes_service_account" "cluster_autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"

#     annotations = {
#       "eks.amazonaws.com/role-arn" = var.cluster_autoscaler_role_arn
#     }

#     labels = {
#       "app.kubernetes.io/name" = "cluster-autoscaler"
#     }
#   }
# }

# resource "helm_release" "cluster_autoscaler" {
#   name       = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   namespace  = "kube-system"

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = var.cluster_name
#   }

#   set {
#     name  = "awsRegion"
#     value = var.aws_region
#   }

#   set {
#     name  = "rbac.serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "rbac.serviceAccount.name"
#     value = kubernetes_service_account.cluster_autoscaler.metadata[0].name
#   }

#   set {
#     name  = "extraArgs.balance-similar-node-groups"
#     value = "true"
#   }

#   set {
#     name  = "extraArgs.skip-nodes-with-system-pods"
#     value = "false"
#   }
#   set {
#     name  = "image.tag"
#     value = "v1.32.0"
#   }
#   depends_on = [
#     kubernetes_service_account.cluster_autoscaler
#   ]
# }
