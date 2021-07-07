resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  description             = "My test VPC"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  description   = "My Test subnet"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
