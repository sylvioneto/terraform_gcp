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

resource "google_compute_firewall" "allow_egress_all" {
  name               = "allow-egress-all"
  description        = "Allow egress to everywhere"
  network            = google_compute_network.vpc.self_link
  direction          = "EGRESS"

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
  name          = "allow-ssh"
  description   = "Allow SSH to the instances from external source"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = [var.ssh_cidr]
  target_tags   = ["allow-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
