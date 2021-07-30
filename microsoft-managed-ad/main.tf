terraform {
  backend "gcs" {
    bucket = "test-microsoft-on-gcp-terraform"
    prefix = "state/microsoft-managed-ad"
  }
}

provider "google" {
  project = "test-microsoft-on-gcp"
  region  = "us-central1"
}
