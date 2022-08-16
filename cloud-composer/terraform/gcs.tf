resource "google_storage_bucket" "sql_backup" {
  name = "${var.project_id}-sql-backup"
  location = var.region
}
