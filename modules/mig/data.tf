data "google_project" "project" {
}

data "google_compute_subnetwork" "subnetwork" {
  name   = var.subnet
  region = var.region
}
