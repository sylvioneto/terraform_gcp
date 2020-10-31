output "gke_metering_dataset" {
  value = google_bigquery_dataset.gke_usage_metering
}

output "vpc" {
  value = google_compute_network.vpc
}
