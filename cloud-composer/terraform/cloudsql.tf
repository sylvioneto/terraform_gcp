resource "random_id" "db_name_suffix" {
  byte_length = 2
}

resource "random_password" "db_initial_password" {
  length = 12
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name                = "private-mssql-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = "SQLSERVER_2019_STANDARD"
  root_password       = random_password.db_initial_password.result # reset it after creation
  deletion_protection = false                                      # not recommended for PROD

  settings {
    tier        = "db-custom-1-3840"
    user_labels = local.resource_labels

    ip_configuration {
      ipv4_enabled    = false
      private_network = module.vpc.network_self_link
    }
  }

  depends_on = [module.vpc]
}

resource "google_sql_database" "adventureworks" {
  name     = "adventureworks"
  instance = google_sql_database_instance.instance.id
}

resource "google_sql_database" "test" {
  name     = "test"
  instance = google_sql_database_instance.instance.id
}
