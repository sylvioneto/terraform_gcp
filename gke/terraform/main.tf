terraform {
  backend "gcs" {
    bucket  = "spedroza-tf-state-dev"
    prefix  = "system1"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}
