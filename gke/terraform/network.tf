# Ref https://github.com/terraform-google-modules/terraform-google-network

# Create VPC
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = var.project_id
  network_name = local.vpc_name
  description  = "VPC for testing GKE cluster"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.cluster_name
      subnet_ip             = "10.1.6.0/24"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${local.cluster_name}" = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/22"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.1.4.0/24"
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

# DNS
resource "google_compute_address" "ingress_external_ip" {
  name         = "${local.cluster_name}-ingress-nginx"
  description  = "NGINX Load balancer IP for ${local.cluster_name}"
  address_type = "EXTERNAL"
}

resource "google_dns_managed_zone" "public" {
  name          = "my-public-zone"
  dns_name      = "${var.dns_domain}."
  description   = "My test DNS domain"
  visibility    = "public"
  force_destroy = true
  labels        = local.resource_labels
}

resource "google_dns_record_set" "root" {
  name = "${var.dns_domain}."
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = [google_compute_address.ingress_external_ip.address]
}
