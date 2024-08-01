variable "activate_apis" {
  type = list(string)
  default = [
    "autoscaling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerfilesystem.googleapis.com",
    "dns.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "all_node_pools_oauth_scopes" {
  type = list(string)
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
  ]
}
