module "network_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name              = "syl-network"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account_id

  auto_create_network            = false
  enable_shared_vpc_host_project = true
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = module.network_project.project_id
  network_name = "shared-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "dev"
      subnet_ip     = "10.0.0.0/16"
      subnet_region = var.region
    },
    {
      subnet_name   = "qa"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
    {
      subnet_name   = "prod"
      subnet_ip     = "10.20.0.0/16"
      subnet_region = var.region
    }
  ]
}

# subnet level access
resource "google_compute_subnetwork_iam_member" "dev_member" {
  project    = module.network_project.project_id
  region     = var.region
  subnetwork = "dev"
  role       = "roles/compute.networkUser"
  member     = "group:${var.developers_group}"
}
