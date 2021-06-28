# Ref https://github.com/terraform-google-modules/terraform-google-network

# Create VPC
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = local.project_id
  network_name = local.vpc_name
  description  = "VPC for testing GKE cluster"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.cluster_name
      subnet_ip             = local.cluster_ip_ranges.nodes
      subnet_region         = local.region
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
  name    = "${local.vpc_name}-nat-router"
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${local.vpc_name}-nat-router"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_address" "ingress_external_ip" {
  name         = "${local.cluster_name}-ingress-nginx"
  description  = "Nginx IP for ${local.cluster_name}"
  address_type = "EXTERNAL"
}

# DNS
resource "google_dns_managed_zone" "public" {
  name          = "my-public-zone"
  dns_name      = "${local.dns_name}."
  description   = "My test DNS domain"
  visibility    = "public"
  force_destroy = true
  labels        = local.resource_labels
}

resource "google_dns_record_set" "root" {
  name = "${local.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = [google_compute_address.ingress_external_ip.address]
}