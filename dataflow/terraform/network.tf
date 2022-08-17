# Ref https://github.com/terraform-google-modules/terraform-google-network

# Create VPC
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.0"
  project_id   = var.project_id
  network_name = "data-engineering"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "dataflow"
      subnet_ip             = "10.1.0.0/22"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]
}

# Allow internal trrafic
resource "google_compute_firewall" "allow-vm-to-vm" {
  name    = "allow-vm-to-vm"
  network = module.vpc.network_self_link

  allow {
    protocol = "all"
    ports    = []
  }

  source_ranges = ["10.0.0.0/16"]
}
