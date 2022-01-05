resource "google_compute_network" "vpc" {
  name                    = "sole-tenant-vpc"
  description             = "VPC for testing Sole-Tenant"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "win-subnet"
  description              = "Subnet to host Windows Server VMs"
  ip_cidr_range            = "10.1.0.0/16"
  region                   = "us-central1"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}
