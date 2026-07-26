resource "kubectl_manifest" "argocd_repo_secret" {
  yaml_body = templatefile(
    "${path.module}/argocd_eso_repo.yaml.tpl",
    {
      argocd_repo_name            = var.argocd_repo_name
      repo_url                    = var.repo_url
      github_app_id               = var.github_app_id
      github_app_installation_id  = var.github_app_installation_id
      github_app_private_key_name = var.github_app_private_key_name
    }
  )

  depends_on = [
    helm_release.argocd,
    helm_release.external_secrets,
    kubernetes_namespace.argocd
  ]
}

resource "kubectl_manifest" "argocd_bootstrap" {
  yaml_body = templatefile(
    "${path.module}/argocd_bootstrap.yaml.tpl",
    {}
  )

  depends_on = [
    kubectl_manifest.argocd_repo_secret
  ]
}

