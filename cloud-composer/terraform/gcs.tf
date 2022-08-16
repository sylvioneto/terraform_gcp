resource "google_storage_bucket" "sql_backup" {
  name                        = "${var.project_id}-sql-backup"
  location                    = var.region
  uniform_bucket_level_access = true
  lifecycle {
    prevent_destroy = false
  }
}
