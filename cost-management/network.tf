resource "google_compute_network" "vpc" {
  name                    = "vpc-cost-mgmt"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev" {
  name                     = "dev"
  description              = "Development subnet"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}
