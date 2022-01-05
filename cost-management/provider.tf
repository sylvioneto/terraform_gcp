terraform {
  backend "gcs" {
  }
}

provider "google" {
  project = "gce-test-syl"
  region  = "us-central1"
}
