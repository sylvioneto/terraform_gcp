resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name                = "private-postgres-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = "POSTGRES_14"
  deletion_protection = false # not recommended for PROD

  settings {
    tier        = "db-g1-small"
    user_labels = var.resource_labels

    ip_configuration {
      ipv4_enabled    = false
      private_network = module.vpc.network_self_link
    }
  }

  depends_on = [module.vpc]
}

resource "google_sql_database" "dvdrental" {
  instance = google_sql_database_instance.instance.id
  name     = "dvdrental"
}

resource "google_sql_user" "airflow" {
  instance = google_sql_database_instance.instance.id
  name     = "airflow"
  password = var.airflow_password
}
