controller:
  replicas: ${replicas}

server:
  replicas: ${replicas}
  ingress:
    enabled: false
    ingressClassName: nginx
    hosts:
      - ${domain_name}
    tls:
      - hosts:
          - ${domain_name}
        secretName: argocd-tls
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/ssl-redirect: "${tls_enabled}"

repoServer:
  replicas: ${replicas}

applicationSet:
  enabled: true
