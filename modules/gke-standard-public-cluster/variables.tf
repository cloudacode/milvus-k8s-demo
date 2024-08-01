variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP project region or zone"
  default     = "us-central1"
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

variable "cluster_regional" {
  type = bool
}

variable "cluster_name" {
  type = string
}

variable "cluster_labels" {
  type        = map(any)
  description = "GKE cluster labels"
}

variable "kubernetes_version" {
  type = string
}

variable "release_channel" {
  type = string
}

variable "cluster_region" {
  type = string
}

variable "cluster_zones" {
  type = list(string)
}
variable "ip_range_pods" {
  type = string
}
variable "ip_range_services" {
  type = string
}
variable "monitoring_enable_managed_prometheus" {
  type    = bool
  default = false
}
variable "gcs_fuse_csi_driver" {
  type    = bool
  default = false
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "all_node_pools_oauth_scopes" {
  type = list(string)
}
variable "all_node_pools_labels" {
  type = map(string)
}
variable "all_node_pools_metadata" {
  type = map(string)
}
variable "all_node_pools_tags" {
  type = list(string)
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "enable_gpu" {
  type        = bool
  description = "Set to true to create GPU node pool"
  default     = true
}

variable "cpu_pools" {
  type = list(map(any))
}

variable "gpu_pools" {
  type = list(map(any))
}

variable "datapath_provider" {
  description = "Enable Dataplanev2 by default"
  type        = string
  default     = "ADVANCED_DATAPATH"
}
