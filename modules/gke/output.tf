output "cluster" {
  value = google_container_cluster.gke
}

output "subnet" {
  value = google_compute_subnetwork.gke_subnet
}
