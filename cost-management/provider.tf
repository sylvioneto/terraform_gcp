terraform {
  backend "gcs" {
    bucket = "tf-state-syl"
    prefix = "terraform-gcp/cost-management"
  }
}

provider "google" {
  project = "gce-test-syl"
  region  = "us-central1"
}
