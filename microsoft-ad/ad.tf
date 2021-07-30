resource "google_compute_network" "admin_vpc" {
  name                    = "admin-network"
  description             = "This VPC hosts administration machines such as Domain Controllers"
  auto_create_subnetworks = false
}

resource "google_active_directory_domain" "ad_domain" {
  domain_name       = "dev.example.com"
  locations         = ["us-central1"]
  reserved_ip_range = "10.1.0.0/24"
  authorized_networks = [
    google_compute_network.admin_vpc.id
  ]

  timeouts {
    create = "60m"
    delete = "2h"
  }
}
