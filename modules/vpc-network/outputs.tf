output "network_name" {
  value = google_compute_network.network.name
}

output "subnets_names" {
  value = [for sb in google_compute_subnetwork.subnetwork : sb.name]
}

output "subnets_ips" {
  value = [for sb in google_compute_subnetwork.subnetwork : sb.ip_cidr_range]
}

output "subnets" {
  value = local.subnets
}
