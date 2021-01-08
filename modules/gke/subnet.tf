resource "google_compute_subnetwork" "gke_subnet" {
  name                     = var.name
  ip_cidr_range            = var.ip_allocation_ranges["nodes"]
  region                   = var.region
  network                  = var.vpc
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.ip_allocation_ranges["pods"]
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.ip_allocation_ranges["services"]
  }
}
