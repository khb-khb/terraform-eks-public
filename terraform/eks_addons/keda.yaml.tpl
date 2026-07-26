serviceAccount:
  operator:
    create: true
    name: keda-operator
    annotations:
      eks.amazonaws.com/role-arn: ${keda_irsa_role_arn}
      eks.amazonaws.com/sts-regional-endpoints: "true"

operator:
  replicaCount: 1

metricsServer:
  replicaCount: 1

webhooks:
  replicaCount: 1