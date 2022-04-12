module "dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name                 = "syl-dev"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${var.region}/subnetworks/dev",
  ]
}

# give developers access to Dev project
resource "google_project_iam_member" "dev_member" {
  project = module.dev.project_id
  role    = "roles/owner"
  member  = "group:${var.developers_group}"
}


module "staging" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name                 = "syl-staging"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${var.region}/subnetworks/staging",
  ]
}


module "prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name                 = "syl-prod"
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account_id
  svpc_host_project_id = module.network_project.project_id

  shared_vpc_subnets = [
    "projects/${module.network_project.project_id}/regions/${var.region}/subnetworks/prod",
  ]
}
