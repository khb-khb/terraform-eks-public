configs:
  params:
    server.insecure: true

server:
  service:
    type: ClusterIP

  ingress:
    enabled: true
    ingressClassName: alb

    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: ${acm_certificate_arn}
      alb.ingress.kubernetes.io/ssl-redirect: "443"
      alb.ingress.kubernetes.io/inbound-cidrs: ${my_ip}
      alb.ingress.kubernetes.io/healthcheck-path: /healthz
      alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
      alb.ingress.kubernetes.io/success-codes: "200"
      external-dns.alpha.kubernetes.io/hostname: argocd.kim-test.shop

    hostname: argocd.kim-test.shop
    paths: /
    pathType: Prefix