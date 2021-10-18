terraform {
  backend "gcs" {
    bucket = "<YOUR-PROJECT-ID>-tf-state"
    prefix = "terraform-demo/gke"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}
