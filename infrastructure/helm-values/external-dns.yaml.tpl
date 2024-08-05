provider: google
domainFilters: ["${domain_name}"]
policy: sync
txtOwnerId: ${domain_name}-${cluster_name}
serviceAccount:
  create: false
  name: external-dns
sources:
  - ingress
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
resources:
  requests:
    cpu: 250m
    memory: 512Mi
