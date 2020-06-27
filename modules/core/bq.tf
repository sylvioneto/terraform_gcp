# Using GKE Usage Metering we can track usage and costs by apps and namespaces.
# It requires a BQ dataset to store the metrics
# Ref https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering
resource "google_bigquery_dataset" "gke_usage_metering" {
  dataset_id  = "gke_usage_metering"
  description = "This dataset stores GKE usage metrics"
  location    = var.bq_location

  labels = {
    project = var.project_id
    purpose = "gke-metering"
    env     = var.env
  }
  delete_contents_on_destroy = true
}
