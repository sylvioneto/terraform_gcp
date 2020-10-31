# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  description             = "VPC managed by terraform"
  auto_create_subnetworks = false
}

# Create NAT and Router
resource "google_compute_router" "nat_router" {
  name    = "${var.project_id}-nat-router"
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.project_id}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
