resource "google_composer_environment" "dev" {
  name   = "composer-dev"
  region = var.region
  labels = local.labels
}