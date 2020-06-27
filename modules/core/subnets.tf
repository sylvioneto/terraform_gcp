resource "google_compute_subnetwork" "subnet" {
  count         = length(var.subnets)
  network       = google_compute_network.vpc.id
  name          = var.subnets[count.index]["name"]
  ip_cidr_range = var.subnets[count.index]["ip_cidr_range"]
  region        = var.subnets[count.index]["region"]
}
