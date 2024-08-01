provider "kubernetes" {
  alias                  = "default"
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "monitoring" {
  provider = kubernetes.default
  metadata {
    name = local.monitoring_namespace
  }
  depends_on = [module.public-gke-standard-cluster]
}

module "monitoring-workload-identity" {
  providers = {
    kubernetes = kubernetes.default
  }
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version    = ">=31.0.0"
  name       = local.monitoring_sa
  namespace  = local.monitoring_namespace
  project_id = local.project_id
  roles      = ["roles/storage.objectUser", ]
  depends_on = [kubernetes_namespace.monitoring]
}

resource "kubernetes_config_map" "grafana_dashboard" {
  provider = kubernetes.default
  metadata {
    name      = "grafana-dashboards"
    namespace = local.monitoring_namespace
  }
  data = {
    "milvus-dashboard.json" = file("${path.module}/grafana/milvus-dashboard.json")
  }
  depends_on = [kubernetes_namespace.monitoring]
}
