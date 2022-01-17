resource "google_composer_environment" "airflow_dev" {
  name   = "airflow-dev"
  region = var.region
  labels = local.labels

  config {
    node_config {
      zone         = "us-central1-a"
      machine_type = "n1-standard-1"

      network    = module.vpc.network_self_link
      subnetwork = module.vpc.subnets_ids[0]

      service_account = google_service_account.test.name
    }

    database_config {
      machine_type = "db-n1-standard-2"
    }

    web_server_config {
      machine_type = "composer-n1-webserver-2"
    }
  }
}
