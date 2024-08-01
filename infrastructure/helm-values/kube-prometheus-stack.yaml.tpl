prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
grafana:
  enabled: true
  persistence:
    enabled: true
    accessModes:
      - ReadWriteOnce
    size: 5Gi
  resources:
    requests:
      cpu: 50m
      memory: 100Mi
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - grafana.${domain_name}
  grafana.ini:
    auth.anonymous:
      enabled: true
  defaultDashboardsEnabled: true
  dashboardsConfigMaps:
    default: grafana-dashboards
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'milvus'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        options:
          path: /var/lib/grafana/dashboards
