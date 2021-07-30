resource "google_compute_firewall" "allow_iap" {
  name    = "allow-ingress-from-iap"
  network = google_compute_network.ad_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  target_tags   = ["allow-ingress-from-iap"]
  source_ranges = ["35.235.240.0/20"]

}
