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
