resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = templatefile(
    "${path.module}/karpenter_node_class.yaml.tpl",
    {
      name                     = var.default_name
      cluster_name             = var.cluster_name
      karpenter_node_role_name = var.karpenter_node_role_name
      workload                 = var.default_workload
    }
  )
  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = templatefile(
    "${path.module}/karpenter_node_pool.yaml.tpl",
    {
      name           = var.default_name
      instance_types = ["t3.medium", "t3.large"]
      cpu_limit      = "6"
      workload       = var.default_workload
    }
  )

  depends_on = [
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_class
  ]
}

resource "kubectl_manifest" "karpenter_pii_node_class" {
  yaml_body = templatefile(
    "${path.module}/karpenter_pii_node_class.yaml.tpl",
    {
      name                     = var.pii_name
      cluster_name             = var.cluster_name
      karpenter_node_role_name = var.karpenter_node_role_name
      workload                 = var.pii_workload
    }
  )
  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_pii_node_pool" {
  yaml_body = templatefile(
    "${path.module}/karpenter_pii_node_pool.yaml.tpl",
    {
      name           = var.pii_name
      instance_types = ["t3.medium", "t3.large"]
      cpu_limit      = "4"
      workload       = var.pii_workload
    }
  )

  depends_on = [
    helm_release.karpenter,
    kubectl_manifest.karpenter_pii_node_class
  ]
}
