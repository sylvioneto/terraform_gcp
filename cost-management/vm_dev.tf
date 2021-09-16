resource "google_compute_instance" "dev1" {
  name         = "vm-dev-001"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  scheduling {
    preemptible = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.dev
  }

  labels = {
    team        = "marketplace"
    cost-center = "BC-09"
    env         = "dev"
  }
}

resource "google_compute_instance" "dev2" {
  name         = "vm-dev-002"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  scheduling {
    preemptible = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.dev
  }

  labels = {
    team        = "payments"
    cost-center = "BC-09"
    env         = "dev"
  }
}
