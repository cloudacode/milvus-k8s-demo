loki:
  commonConfig:
    replication_factor: 1
  auth_enabled: false
  schemaConfig:
    configs:
      - from: 2024-04-01
        store: tsdb
        object_store: gcs
        schema: v13
        index:
          prefix: loki_index_
          period: 24h
  storage:
    type: gcs
    bucketNames:
      chunks: ${bucket_name}
      ruler: ${bucket_name}
      admin: ${bucket_name}

serviceAccount:
  create: false
  name: ${monitoring_sa}
  annotations:
    iam.gke.io/gcp-service-account: ${monitoring_sa}@${project_name}.iam.gserviceaccount.com

chunksCache:
  allocatedMemory: 4096
