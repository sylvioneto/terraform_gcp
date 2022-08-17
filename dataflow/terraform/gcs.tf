resource "google_storage_bucket" "data_raw" {
  name                        = "${var.project_id}-data-raw"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

resource "google_storage_bucket" "data_lake" {
  name                        = "${var.project_id}-data-lake"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

resource "google_storage_bucket" "data_warehouse" {
  name                        = "${var.project_id}-data-warehouse"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

resource "google_storage_bucket" "dataflow_temp_warehouse" {
  name                        = "${var.project_id}-dataflow-temp"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}
