# Ref https://github.com/terraform-google-modules/terraform-google-network

# Create VPC
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.0"
  project_id   = var.project_id
  network_name = "dev-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "data-engineering"
      subnet_ip             = "10.1.0.0/22"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]
}

# NAT and Router
resource "google_compute_router" "nat_router" {
  name    = "${module.vpc.network_name}-nat-router"
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${module.vpc.network_name}-nat-gw"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


# Allow internal trrafic
resource "google_compute_firewall" "allow-vm-to-vm" {
  name        = "allow-vm-to-vm"
  network     = module.vpc.network_self_link

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.1.0.0/22"]
}