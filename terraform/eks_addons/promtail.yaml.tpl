config:
  clients:
    - url: ${loki_url}

tolerations:
  - key: workload
    operator: Equal
    value: pii
    effect: NoSchedule