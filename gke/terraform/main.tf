terraform {
  backend "gcs" {
    bucket  = "spedroza-tf-state-dev"
    prefix  = "system1"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
