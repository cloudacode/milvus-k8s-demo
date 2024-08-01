output "cluster" {
  value = module.gke
}

output "endpoint" {
  value = module.gke.endpoint
}

output "ca_certificate" {
  value = module.gke.ca_certificate
}
