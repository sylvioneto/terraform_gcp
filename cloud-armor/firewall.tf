resource "google_compute_firewall" "allow_ssh" {
  name    = "${module.vpc.network_name}-allow-ssh-from-iap"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports     = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}
