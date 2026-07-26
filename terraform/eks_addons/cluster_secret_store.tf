resource "kubectl_manifest" "cluster_secret_store_aws_secretsmanager" {
  yaml_body = templatefile(
    "${path.module}/cluster_secret_store.yaml.tpl",
    {
      region = var.aws_region
    }
  )


  depends_on = [
    helm_release.external_secrets
  ]
}
