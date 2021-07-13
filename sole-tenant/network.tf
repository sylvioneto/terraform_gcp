resource "google_compute_network" "vpc_network" {
  name                    = "sole-tenant"
  description             = "VPC for testing Sole-Tenant"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet-win-us"
  description              = "Subnet to host Windows Server VMs"
  ip_cidr_range            = "10.0.0.0/22"
  region                   = "us-central1"
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}
