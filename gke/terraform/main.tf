terraform {
  backend "gcs" {
    bucket = "<YOUR-PROJECT-ID>-tf-state"
    prefix = "terraform-gcp/gke"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}
