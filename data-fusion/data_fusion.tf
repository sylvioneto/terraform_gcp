resource "google_data_fusion_instance" "basic_instance" {
  provider = google-beta
  name     = "data-fusion-dev-001"
  region   = "us-east1"
  type     = "BASIC"
  labels   = local.labels
}
