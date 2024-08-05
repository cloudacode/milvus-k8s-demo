locals {
  project_id  = "cloud-ai-compute-prod"
  prefix_name = "vector-db-demo"
  domain_name = "dev.cloudacode.com"
  location    = "asia-northeast3"

  bucket_name = "${local.prefix_name}-${local.location}-bucket"

  network_name           = "${local.prefix_name}-network"
  subnetwork_name        = "${local.network_name}-${local.location}-subnet"
  subnetwork_cidr        = "10.100.0.0/16"
  subnetwork_description = "Subnetwork for ${local.prefix_name} resources on ${local.location}"
  ip_range_pods          = "${local.subnetwork_name}-pods"
  ip_range_services      = "${local.subnetwork_name}-services"

  cluster_name     = "${local.prefix_name}-cluster"
  cluster_location = local.location
  cluster_zones = [
    # "${local.cluster_location}-a",
    "${local.cluster_location}-b",
    # "${local.cluster_location}-c",
  ]

  monitoring_namespace = "monitoring"
  monitoring_sa        = "monitoring"
}
