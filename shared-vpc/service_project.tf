module "dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-dev"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/dev",
  ]
}


module "qa" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-qa"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/qa",
  ]
}


module "prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-prod"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/prod",
  ]
}
