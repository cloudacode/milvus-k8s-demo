resource "google_compute_network" "network" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  description             = var.description
}

locals {
  subnets = {
    for subnet in var.subnets :
    "${subnet.subnet_region}/${subnet.subnet_name}" => subnet
  }
}

## Create subnetwork
resource "google_compute_subnetwork" "subnetwork" {
  for_each                   = local.subnets
  name                       = each.value.subnet_name
  ip_cidr_range              = each.value.subnet_ip
  region                     = each.value.subnet_region
  private_ip_google_access   = lookup(each.value, "subnet_private_access", "false")
  private_ipv6_google_access = lookup(each.value, "subnet_private_ipv6_access", null)
  dynamic "log_config" {
    for_each = coalesce(lookup(each.value, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = each.value.subnet_flow_logs_interval
      flow_sampling        = each.value.subnet_flow_logs_sampling
      metadata             = each.value.subnet_flow_logs_metadata
      filter_expr          = each.value.subnet_flow_logs_filter
      metadata_fields      = each.value.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }
  network     = google_compute_network.network.name
  project     = var.project_id
  description = lookup(each.value, "description", null)
  dynamic "secondary_ip_range" {
    for_each = contains(keys(var.secondary_ranges), each.value.subnet_name) == true ? var.secondary_ranges[each.value.subnet_name] : []

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  purpose          = lookup(each.value, "purpose", null)
  role             = lookup(each.value, "role", null)
  stack_type       = lookup(each.value, "stack_type", null)
  ipv6_access_type = lookup(each.value, "ipv6_access_type", null)

  lifecycle {
    ignore_changes = [secondary_ip_range]
  }
}

resource "google_compute_global_address" "google-managed-services-range" {
  count         = var.create_psa ? 1 : 0
  project       = var.project_id
  name          = "google-managed-services-${var.network_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.self_link
}

# Creates the peering with the producer network.
resource "google_service_networking_connection" "private_service_access" {
  count                   = var.create_psa ? 1 : 0
  network                 = google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google-managed-services-range[0].name]
  # This will enable a successful terraform destroy when destroying CloudSQL instances
  deletion_policy = "ABANDON"
  depends_on      = [google_compute_network.network]
}
