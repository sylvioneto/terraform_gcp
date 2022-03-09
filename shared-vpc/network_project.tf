module "network_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = local.network_project_id
  random_project_id = false
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
      subnet_region = local.region
    },
    {
      subnet_name   = "qa"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = local.region
    },
    {
      subnet_name   = "prod"
      subnet_ip     = "10.20.0.0/16"
      subnet_region = local.region
    }
  ]
}
