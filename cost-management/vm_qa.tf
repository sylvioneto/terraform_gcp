resource "google_compute_instance" "qa1" {
  name         = "vm-qa-001"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  scheduling {
    preemptible = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = google_compute_subnetwork.qa.self_link
  }

  labels = {
    team        = "finance"
    cost-center = "002-01"
    env         = "qa"
  }
}

resource "google_compute_instance" "qa2" {
  name         = "vm-qa-002"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  scheduling {
    preemptible = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = google_compute_subnetwork.qa.self_link
  }

  labels = {
    team        = "research"
    cost-center = "002-02"
    env         = "qa"
  }
}