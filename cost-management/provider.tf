terraform {
  backend "gcs" {
    bucket = "tf-state-syl"
    prefix = "terraform-gcp/cost-management"
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
