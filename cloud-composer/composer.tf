resource "google_composer_environment" "dev" {
  name   = "composer-dev"
  region = var.region
  config {
    node_count = 2

    node_config {
      zone         = "${var.region}-b"
      machine_type = "n1-standard-1"

      network    = module.vpc.network_self_link
      subnetwork = module.vpc.subnets_ids[0]

      service_account = google_service_account.dev.name
    }

    database_config {
      machine_type = "db-n1-standard-2"
    }

    web_server_config {
      machine_type = "composer-n1-webserver-2"
    }
  }
}

resource "google_service_account" "dev" {
  account_id   = "composer-dev"
  display_name = "Test Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  role   = "roles/composer.worker"
  member = "serviceAccount:${google_service_account.dev.email}"
}

resource "google_project_iam_member" "composer-worker" {
  role   = "roles/composer.editor"
  member = "serviceAccount:${google_service_account.dev.email}"
}
