module "dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-dev"
  org_id               = var.org_id
  billing_account      = var.billing_account
  svpc_host_project_id = module.network_project.project_id

  # shared_vpc_subnets = [
  #   "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/dev",
  # ]
}


module "qa" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-qa"
  org_id               = var.org_id
  billing_account      = var.billing_account
  svpc_host_project_id = module.network_project.project_id

  # shared_vpc_subnets = [
  #   "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/qa",
  # ]
}


module "prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "syl-prod"
  org_id               = var.org_id
  billing_account      = var.billing_account
  svpc_host_project_id = module.network_project.project_id

    # shared_vpc_subnets = [
  #   "projects/${module.network_project.project_id}/regions/${local.region}/subnetworks/prod",
  # ]
}
