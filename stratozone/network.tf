resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  description             = "My test VPC"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  description   = "My Test subnet"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_stratozone" {
  name    = "allow-stratozone"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_tags = ["stratozone"]
}

resource "google_compute_firewall" "allow_iap" {
  name        = "allow-iap"
  description = "Allow SSH and RDP with IAP"
  network     = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap"]
}
