output "gke_metering_dataset" {
  value = google_bigquery_dataset.gke_usage_metering
}

output "vpc" {
  value = google_compute_network.vpc
}

output "vm_log_bucket" {
  value = google_storage_bucket.vm_logs.name
}

output "cloudbuild_log_bucket" {
  value = google_storage_bucket.cloudbuild_logs.name
}

output "subnets" {
  value = google_compute_subnetwork.subnet[*].name
}
