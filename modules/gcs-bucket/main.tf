resource "google_storage_bucket" "static" {
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = true
  public_access_prevention    = "enforced"
}
