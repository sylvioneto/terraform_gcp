resource "google_compute_network" "vpc_network" {
  name                    = "vpc-dev"
  description             = "VPC for development"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "sole-tenant"
  description   = "Subnet to host sole-tenant nodes"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
