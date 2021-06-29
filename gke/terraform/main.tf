terraform {
  backend "gcs" {
    bucket  = "sylvio-tf-state"
    prefix  = "terraform-demo/gke"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}
