module "composer" {
  source  = "terraform-google-modules/composer/google"
  version = "~> 2.0"

  project_id        = var.project_id
  region            = var.region
  zone              = "${var.region}-b"
  composer_env_name = local.composer_env_name
  network           = module.vpc.network_name
  subnetwork        = local.composer_env_name
}
