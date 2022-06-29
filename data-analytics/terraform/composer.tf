module "composer" {
  source  = "terraform-google-modules/composer/google"
  version = "~> 2.0"

  project_id        = var.project_id
  region            = var.region
  composer_env_name = local.composer_env_name
  network           = module.vpc.network_name
  subnetwork        = local.composer_env_name
  enable_private_endpoint = false

}
