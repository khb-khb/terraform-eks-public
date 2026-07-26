apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: cloudwatch-exporter
  namespace: monitoring
  labels:
    release: kube-prometheus-stack
spec:
  selector:
    matchLabels:
      app: prometheus-cloudwatch-exporter
      release: cloudwatch-exporter
  namespaceSelector:
    matchNames:
      - monitoring
  endpoints:
    - port: http
      path: /metrics
      interval: 60s