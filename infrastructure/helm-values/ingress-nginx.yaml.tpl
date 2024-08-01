controller:
  kind: Deployment
  podLabels:
    "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
  # extraArgs:
  #   default-ssl-certificate: "ingress-nginx/wildcard-cloudacode-com"
  #   enable-ssl-passthrough: "true"
  config:
    ssl-redirect: "false"
    log-format-escape-json: "true"
    log-format-upstream: '{"ts": "$time_iso8601", "requestID": "$req_id", "upstreamAddr": "$upstream_addr", "proxyUpstreamName": "$proxy_upstream_name", "proxyAlternativeUpstreamName": "$proxy_alternative_upstream_name", "requestMethod": "$request_method", "requestUrl": "$host$uri?$args", "status": $status, "upstreamStatus": "$upstream_status", "requestSize": "$request_length", "responseSize": "$upstream_response_length", "userAgent": "$http_user_agent", "remoteIp": "$remote_addr", "referer": "$http_referer", "latency": "$upstream_response_time"}'
    use-gzip: "true"
    gzip-types: "*"
  watchIngressWithoutClass: "true"
  ingressClassResource:
    default: true
  resources:
    requests:
      cpu: 100m
      memory: 200Mi
  service:
    annotations:
      type: LoadBalancer
      externalTrafficPolicy: "Local"
    externalTrafficPolicy: "Local"
  autoscaling:
    enabled: true
    minReplicas: 1
    maxReplicas: 10
    targetCPUUtilizationPercentage: 60
    targetMemoryUtilizationPercentage: 60
  metrics:
    enabled: true
    service:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "10254"
    serviceMonitor:
      enabled: true
defaultBackend:
  enabled: true
