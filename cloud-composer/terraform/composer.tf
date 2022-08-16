module "composer" {
  source  = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version = "3.2.0"

  project_id               = var.project_id
  region                   = var.region
  composer_env_name        = local.composer_env_name
  composer_service_account = google_service_account.service_account.email
  image_version            = "composer-2.0.1-airflow-2.1.4"
  environment_size         = "ENVIRONMENT_SIZE_SMALL"
  labels                   = local.resource_labels

  network                          = module.vpc.network_name
  subnetwork                       = local.composer_env_name
  master_ipv4_cidr                 = local.composer_ip_ranges.master
  service_ip_allocation_range_name = "services"
  pod_ip_allocation_range_name     = "pods"
  enable_private_endpoint          = true


  # Pre-installed packages https://cloud.google.com/composer/docs/concepts/versioning/composer-versions
  pypi_packages = {
    # add custom packages here 
  }

  depends_on = [
    module.vpc
  ]
}
