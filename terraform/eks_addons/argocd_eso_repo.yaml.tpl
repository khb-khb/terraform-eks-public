apiVersion: external-secrets.io/v1
kind: ExternalSecret

metadata:
  name: ${argocd_repo_name}
  namespace: argocd

spec:
  refreshInterval: 1m

  secretStoreRef:
    name: aws-secretsmanager
    kind: ClusterSecretStore

  target:
    name: ${argocd_repo_name}
    creationPolicy: Owner

    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: repository

      data:
        type: git
        url: ${repo_url}
        githubAppID: "${github_app_id}"
        githubAppInstallationID: "${github_app_installation_id}"
        githubAppPrivateKey: "{{ .githubAppPrivateKey }}"

  data:
    - secretKey: githubAppPrivateKey
      remoteRef:
        key: ${github_app_private_key_name}