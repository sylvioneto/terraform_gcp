module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0"
  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet-${var.region}"
      subnet_ip             = var.subnet_cidr
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${module.vpc.network_name}-allow-ssh-from-iap"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]

  target_tags = [
    "allow-ssh"
  ]
}

resource "google_compute_firewall" "allow_rdp" {
  name    = "${module.vpc.network_name}-allow-rdp-from-iap"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]

  target_tags = [
    "allow-rdp"
  ]
}

resource "google_compute_firewall" "allow_hc" {
  name    = "${module.vpc.network_name}-allow-health-checks"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
  }
  
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = [
    "allow-hc"
  ]
}

resource "google_compute_global_address" "service_range" {
  name          = "service-networking"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = var.service_networking
  prefix_length = 16
  network       = module.vpc.network_name
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}
