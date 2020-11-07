resource "google_compute_firewall" "allow_internal_all" {
  name          = "allow-internal-all"
  description   = "Allow ingress from all instances within the VPC"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = [var.vpc_cidr]
  target_tags   = ["allow-internal-all"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_external_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH to the instances from external source"
  network     = google_compute_network.vpc.self_link
  direction   = "INGRESS"
  source_ranges = concat(
    var.ssh_cidrs,
    // Google IAP https://cloud.google.com/iap/docs/using-tcp-forwarding
    ["35.235.240.0/20"],
  )

  target_tags = ["allow-ext-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_ingress_http" {
  name          = "allow-http"
  description   = "Allow HTTP ingress traffic from the internet"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http"]

  allow {
    protocol = "tcp"
    ports = [
      "80", "8080", "443"
    ]
  }
}

resource "google_compute_firewall" "allow_google_hc" {
  name          = "allow-google-health-checks"
  description   = "Allow Google Health Checks"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
  }
}
