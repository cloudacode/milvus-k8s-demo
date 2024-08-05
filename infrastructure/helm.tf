provider "helm" {
  alias = "default"
  kubernetes {
    host                   = "https://${data.google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
  }
}

# Prometheus
resource "helm_release" "prometheus" {
  provider   = helm.default
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.6.0"
  namespace  = local.monitoring_namespace
  values = [templatefile("${path.module}/helm-values/kube-prometheus-stack.yaml.tpl", {
    domain_name = local.domain_name
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    kubernetes_namespace.monitoring,
    module.workload_identity_monitoring,
    kubernetes_config_map.grafana_dashboard,
  ]
}

# Ingress Nginx
resource "helm_release" "ingress_nginx" {
  provider         = helm.default
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.1"
  namespace        = "ingress-nginx"
  create_namespace = true
  values           = [templatefile("${path.module}/helm-values/ingress-nginx.yaml.tpl", {})]
  wait             = false
  wait_for_jobs    = false
  depends_on       = [helm_release.prometheus]
}

# External DNS
resource "helm_release" "external_dns" {
  provider   = helm.default
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.14.5"
  namespace  = "external-dns"
  values = [templatefile("${path.module}/helm-values/external-dns.yaml.tpl", {
    domain_name  = local.domain_name
    cluster_name = local.cluster_name
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    kubernetes_namespace.external_dns,
    module.workload_identity_external_dns,
    helm_release.prometheus
  ]
}

# Loki
resource "helm_release" "loki" {
  provider   = helm.default
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.7.3"
  namespace  = local.monitoring_namespace
  values = [templatefile("${path.module}/helm-values/loki.yaml.tpl", {
    bucket_name   = local.bucket_name
    project_name  = local.project_id
    monitoring_sa = local.monitoring_sa
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    module.workload_identity_monitoring,
    kubernetes_namespace.monitoring,
    module.gcs
  ]
}

# Promtail
resource "helm_release" "promtail" {
  provider   = helm.default
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.4"
  namespace  = local.monitoring_namespace
  values = [templatefile("${path.module}/helm-values/promtail.yaml.tpl", {
    monitoring_namespace = local.monitoring_namespace
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    helm_release.loki,
    kubernetes_namespace.monitoring
  ]
}

# Milvus
resource "helm_release" "milvus" {
  provider         = helm.default
  name             = "milvus"
  repository       = "https://zilliztech.github.io/milvus-helm"
  chart            = "milvus"
  version          = "4.2.0"
  namespace        = "milvus"
  create_namespace = true
  values = [templatefile("${path.module}/helm-values/milvus.yaml.tpl", {
    domain_name = local.domain_name
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.prometheus
  ]
}

# Qdrant
resource "helm_release" "qdrant" {
  provider         = helm.default
  name             = "qdrant"
  repository       = "https://qdrant.github.io/qdrant-helm"
  chart            = "qdrant"
  version          = "0.10.1"
  namespace        = "qdrant"
  create_namespace = true
  values = [templatefile("${path.module}/helm-values/qdrant.yaml.tpl", {
    domain_name = local.domain_name
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.prometheus
  ]
}

# JupyterHub
resource "helm_release" "jupyterhub" {
  provider         = helm.default
  name             = "jupyterhub"
  repository       = "https://hub.jupyter.org/helm-chart"
  chart            = "jupyterhub"
  version          = "3.3.7"
  namespace        = "jupyterhub"
  create_namespace = true
  values = [templatefile("${path.module}/helm-values/jupyterhub.yaml.tpl", {
    domain_name = local.domain_name
  })]
  wait          = false
  wait_for_jobs = false

  depends_on = [
    helm_release.ingress_nginx,
  ]
}
