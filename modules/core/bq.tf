# This BQ Dataset is used for GKE Usage Metering.
# Ref https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering
resource "google_bigquery_dataset" "gke_usage_metering" {
  dataset_id  = "gke_usage_metering"
  description = "This dataset stores GKE usage metrics"
  location    = var.bq_location

  labels = merge(local.labels, {purpose="gke-metering"})
  delete_contents_on_destroy = true
}
