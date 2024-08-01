metrics:
  enabled: true
  serviceMonitor:
    enabled: true
attu:
  enabled: true
  ingress:
    enabled: true
    labels: {}
    hosts:
      - milvus-attu.${domain_name}
minio:
  enabled: true
  mode: standalone
  persistence:
    size: 100Gi
pulsar:
  bookkeeper:
    volumes:
      journal:
        name: journal
        size: 20Gi
      ledgers:
        name: ledgers
        size: 40Gi
