resource "google_compute_network" "admin_vpc" {
  name                    = "ad-network"
  description             = "This VPC peers with Microsoft Managed AD and hosts bastions"
  auto_create_subnetworks = false
}

resource "google_active_directory_domain" "ad_domain" {
  domain_name       = "managed-ad.example.com"
  locations         = ["us-central1"]
  reserved_ip_range = "10.0.1.0/24"
  authorized_networks = [
    google_compute_network.admin_vpc.id
  ]

}
