ingress:
  enabled: true
  ingressClassName: nginx
  hosts:
    - host: qdrant.${domain_name}
      paths:
        - path: /
          pathType: Prefix
          servicePort: 6333
metrics:
  serviceMonitor:
    enabled: true
