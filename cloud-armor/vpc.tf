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
