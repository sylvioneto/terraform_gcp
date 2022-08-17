# Ref https://github.com/terraform-google-modules/terraform-google-network

# Create VPC
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "5.1.0"
  project_id   = var.project_id
  network_name = local.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.cluster_name
      subnet_ip             = local.cluster_ip_ranges.nodes
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${local.cluster_name}" = [
      {
        range_name    = "pods"
        ip_cidr_range = local.cluster_ip_ranges.pods
      },
      {
        range_name    = "services"
        ip_cidr_range = local.cluster_ip_ranges.services
      },
    ]
  }
}

# NAT and Router
resource "google_compute_router" "nat_router" {
  name    = "${module.vpc.network_name}-nat-router"
  network = module.vpc.network_self_link
  region  = var.region

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


# Firewall for nginx
# https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#add_firewall_rules
resource "google_compute_firewall" "nginx_admission" {
  name        = "${local.cluster_name}-master-to-worker"
  network     = module.vpc.network_self_link
  description = "Creates a nginx firewall rule from master to workers"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8443", "10254"]
  }

  source_ranges = [local.cluster_ip_ranges.master]
  target_tags   = [local.cluster_name]
}


resource "google_compute_firewall" "allow_iap" {
  name        = "${local.cluster_name}-allow-iap"
  network     = module.vpc.network_self_link
  description = "Allow IAP to VMs"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = [local.cluster_name]
}
