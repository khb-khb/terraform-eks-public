apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bootstrap
  namespace: argocd
spec:
  project: default

  source:
    repoURL: https://github.com/khb-khb/terraform-eks.git
    targetRevision: master
    path: applicationsets

  destination:
    server: https://kubernetes.default.svc
    namespace: argocd

  syncPolicy:
    automated:
      prune: true
      selfHeal: true