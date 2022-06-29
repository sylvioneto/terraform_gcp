module "composer" {
  source  = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version = "~> 3.1"

  project_id              = var.project_id
  composer_env_name       = local.composer_env_name
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = local.composer_env_name
  enable_private_endpoint = true
  labels                  = local.resource_labels

  depends_on = [
    module.vpc
  ]
}
