resource "google_compute_instance" "dev1" {
  name         = "vm-dev-001"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = google_compute_subnetwork.dev.self_link
  }

  labels = {
    team        = "marketplace"
    cost-center = "001-09"
    env         = "dev"
  }
}

resource "google_compute_instance" "dev2" {
  name         = "vm-dev-002"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = google_compute_subnetwork.dev.self_link
  }

  labels = {
    team        = "payments"
    cost-center = "001-08"
    env         = "dev"
  }
}
