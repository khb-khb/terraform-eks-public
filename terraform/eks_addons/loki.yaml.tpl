deploymentMode: SingleBinary

serviceAccount:
  create: true
  name: loki
  annotations:
    eks.amazonaws.com/role-arn: ${loki_role_arn}

loki:
  auth_enabled: false

  commonConfig:
    replication_factor: 1

  schemaConfig:
    configs:
      - from: "2024-04-01"
        store: tsdb
        object_store: s3
        schema: v13
        index:
          prefix: loki_index_
          period: 24h

  storage:
    type: s3
    bucketNames:
      chunks: ${loki_bucket_name}
      ruler: ${loki_bucket_name}
      admin: ${loki_bucket_name}
    s3:
      region: us-west-2

singleBinary:
  replicas: ${loki_replicas}
  nodeSelector:
    nodegroup: managed
  persistence:
    enabled: false

  extraVolumes:
    - name: loki-storage
      emptyDir: {}

  extraVolumeMounts:
    - name: loki-storage
      mountPath: /var/loki

read:
  replicas: 0

write:
  replicas: 0

backend:
  replicas: 0

gateway:
  enabled: false

minio:
  enabled: false

lokiCanary:
  enabled: false

chunksCache:
  enabled: false

resultsCache:
  enabled: false

test:
  enabled: false