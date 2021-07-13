terraform {
  backend "google" {
    bucket = "sylvio-tf-state"
    prefix = "terraform-examples/sole-tenant"
  }
}

provider "google" {
  project = "sylvio-terraform-demo"
  region  = "us-central1"
}
