module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0"
  project_id   = var.project_id
  network_name = "vpc-data-analytics"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.composer_env_name
      subnet_ip             = var.composer_ip_ranges.nodes
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${var.composer_env_name}" = [
      {
        range_name    = "pods"
        ip_cidr_range = var.composer_ip_ranges.pods
      },
      {
        range_name    = "services"
        ip_cidr_range = var.composer_ip_ranges.services
      },
    ]
  }
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
