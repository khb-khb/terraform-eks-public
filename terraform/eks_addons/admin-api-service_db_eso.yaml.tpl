apiVersion: external-secrets.io/v1
kind: ExternalSecret

metadata:
  name: admin-api-db-external-secret
  namespace: ${namespace}

spec:
  refreshInterval: 1m

  secretStoreRef:
    name: aws-secretsmanager
    kind: ClusterSecretStore

  target:
    name: admin-api-db-secret
    creationPolicy: Owner

  data:
    - secretKey: DB_HOST
      remoteRef:
        key: admin-db
        property: DB_HOST

    - secretKey: DB_PORT
      remoteRef:
        key: admin-db
        property: DB_PORT

    - secretKey: DB_NAME
      remoteRef:
        key: admin-db
        property: DB_NAME

    - secretKey: DB_USER
      remoteRef:
        key: admin-db
        property: DB_USER

    - secretKey: DB_PASSWORD
      remoteRef:
        key: admin-db
        property: DB_PASSWORD