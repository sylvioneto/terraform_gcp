module "composer" {
  source  = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version = "~> 3.1"

  project_id               = var.project_id
  composer_env_name        = local.composer_env_name
  composer_service_account = google_service_account.service_account.email
  region                   = var.region
  image_version            = "composer-2-airflow-2"

  network                          = module.vpc.network_name
  subnetwork                       = local.composer_env_name
  master_ipv4_cidr                 = local.ip_ranges.master
  service_ip_allocation_range_name = "services"
  pod_ip_allocation_range_name     = "pods"
  enable_private_endpoint          = true
  labels                           = local.resource_labels

  depends_on = [
    module.vpc
  ]
}
