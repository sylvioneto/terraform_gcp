terraform {
  backend "gcs" {
  }
}

provider "google" {
  project = var.project_id
  region  = "southamerica-east1"
}
