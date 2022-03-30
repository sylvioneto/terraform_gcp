resource "google_compute_firewall" "allow_health_check" {
  name    = "${module.vpc.network_name}-allow-health-check"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = ["allow-health-check"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "${module.vpc.network_name}-allow-http"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports     = ["80"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = ["allow-http"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${module.vpc.network_name}-allow-ssh"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports     = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}
