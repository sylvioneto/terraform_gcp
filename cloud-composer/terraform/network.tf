module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0"
  project_id   = var.project_id
  network_name = "data-analytics-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.composer_env_name
      subnet_ip             = local.ip_ranges.nodes
      subnet_region         = var.region
      subnet_private_access = true
    },
    {
      subnet_name           = "gce-databases"
      subnet_ip             = local.ip_ranges.gce_databases
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${local.composer_env_name}" = [
      {
        range_name    = "pods"
        ip_cidr_range = local.ip_ranges.pods
      },
      {
        range_name    = "services"
        ip_cidr_range = local.ip_ranges.services
      },
    ]
  }
}

resource "google_compute_firewall" "allow_rdp_ssh" {
  name    = "${module.vpc.network_name}-allow-rdp-ssh-from-iap"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]

  target_tags = [
    "allow-ssh", 
    "allow-rdp"
  ]
}

resource "google_compute_global_address" "service_range" {
  name          = "service-networking-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "10.200.0.0"
  prefix_length = 16
  network       = module.vpc.network_name
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}

