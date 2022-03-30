module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.0"
  project_id   = var.project_id
  network_name = "cloud-armor-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "webapp-${var.region}"
      subnet_ip             = var.webapp_cidr
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
    ports     = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}
