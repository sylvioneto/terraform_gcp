resource "google_storage_bucket" "raw" {
  name                        = "${var.project_id}-data-raw"
  location                    = "us-east1"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

resource "google_storage_bucket" "data_lake" {
  name                        = "${var.project_id}-data-raw"
  location                    = "us-east1"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

resource "google_storage_bucket" "data_warehouse" {
  name                        = "${var.project_id}-data-warehouse"
  location                    = "us-east1"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}
