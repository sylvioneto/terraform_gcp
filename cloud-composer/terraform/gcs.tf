resource "google_storage_bucket" "sql_backup" {
  name                        = "${var.project_id}-sql-backup"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "data_lake" {
  name                        = "${var.project_id}-data-lake"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}
