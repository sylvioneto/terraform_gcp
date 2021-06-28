terraform {
  backend "gcs" {
    bucket  = "spedroza-tf-state-dev"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
