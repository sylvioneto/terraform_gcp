resource "google_compute_instance" "prod1" {
  name         = "vm-prod-001"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.prod
  }

  labels = {
    team        = "finance"
    cost-center = "CC-09"
    env         = "prod"
  }
}

resource "google_compute_instance" "prod2" {
  name         = "vm-prod-002"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.prod
  }

  labels = {
    team        = "human-resources"
    cost-center = "CC-09"
    env         = "prod"
  }
}

resource "google_compute_instance" "prod3" {
  name         = "vm-prod-003"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.prod
  }

  labels = {
    team        = "marteting"
    cost-center = "CC-09"
    env         = "prod"
  }
}

