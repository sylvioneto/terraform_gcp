resource "google_composer_environment" "airflow_dev" {
  name   = "airflow-dev"
  region = var.region
  labels = local.labels

  config {
    node_config {
      zone         = "${var.region}-a"
      machine_type = "n1-standard-1"

      network    = module.vpc.network_self_link
      subnetwork = module.vpc.subnets_ids[0]
    }

    database_config {
      machine_type = "db-n1-standard-2"
    }

    web_server_config {
      machine_type = "composer-n1-webserver-2"
    }
  }
}
