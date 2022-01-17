resource "google_composer_environment" "dev" {
  name   = "composer-dev"
  region = var.region
  labels = local.labels

  config {
    node_count = 4

    node_config {
      network    = google_compute_network.test.id
      subnetwork = google_compute_subnetwork.test.id
    }
  }
}