
## Enable Required GCP Project Services APIs
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.5"

  project_id                  = local.project_id
  disable_services_on_destroy = false
  disable_dependent_services  = false
  activate_apis               = flatten(var.activate_apis)
}

module "custom-vpc-network" {
  source       = "../modules/vpc-network"
  project_id   = local.project_id
  network_name = local.network_name
  create_psa   = true

  subnets = [
    {
      subnet_region         = local.cluster_location
      subnet_name           = local.subnetwork_name
      description           = local.subnetwork_description
      subnet_ip             = local.subnetwork_cidr
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    (local.subnetwork_name) = [
      {
        range_name    = local.ip_range_pods
        ip_cidr_range = "192.168.0.0/20"
      },
      {
        range_name    = local.ip_range_services
        ip_cidr_range = "192.168.48.0/20"
      }
    ]
  }

  depends_on = [module.project-services]
}

module "gcs" {
  source      = "../modules/gcs-bucket"
  project_id  = local.project_id
  bucket_name = local.bucket_name
  region      = local.cluster_location
}

# create public GKE standard
module "public-gke-standard-cluster" {
  source     = "../modules/gke-standard-public-cluster"
  project_id = local.project_id

  ## network values
  network_name    = local.network_name
  subnetwork_name = local.subnetwork_name

  ## gke variables
  cluster_regional = true
  cluster_region   = local.cluster_location
  cluster_zones    = local.cluster_zones
  cluster_name     = local.cluster_name
  cluster_labels = {
    "cluster" = local.prefix_name
  }
  kubernetes_version                   = "1.29"
  release_channel                      = "REGULAR"
  ip_range_pods                        = local.ip_range_pods
  ip_range_services                    = local.ip_range_services
  monitoring_enable_managed_prometheus = false
  gcs_fuse_csi_driver                  = true
  master_authorized_networks           = []
  deletion_protection                  = false

  ## pools config variables
  cpu_pools = [{
    name               = "cpu-pool"
    machine_type       = "n1-standard-8"
    autoscaling        = true
    spot               = true
    initial_node_count = 2
    min_count          = 1
    max_count          = 6
    enable_gcfs        = true
    disk_size_gb       = 100
    disk_type          = "pd-standard"
  }]

  enable_gpu                  = false
  gpu_pools                   = []
  all_node_pools_oauth_scopes = var.all_node_pools_oauth_scopes
  all_node_pools_labels = {
    "cluster" = "${local.cluster_name}-node-pool"
  }
  all_node_pools_metadata = {
    disable-legacy-endpoints = "true"
  }
  all_node_pools_tags = [local.cluster_name, "gke-node", ]
  depends_on          = [module.custom-vpc-network]
}

data "google_container_cluster" "default" {
  name       = local.cluster_name
  location   = local.cluster_location
  depends_on = [module.public-gke-standard-cluster]
}

data "google_client_config" "default" {}
