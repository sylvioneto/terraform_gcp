resource "google_composer_environment" "dev" {
  name   = "composer-dev"
  region = var.region
  labels = local.labels

  config {
    node_count = 4

    node_config {
      network    = module.vpc.network_self_link
    }
  }
}