resource "google_bigquery_dataset" "ecommerce" {
  dataset_id                  = "ecommerce"
  description                 = "ecommerce data ingested by GCP Data Fusion"
  location                    = "us-east1"
  default_table_expiration_ms = 3600000

  labels = local.labels
}
