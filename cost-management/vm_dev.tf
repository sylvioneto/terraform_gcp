resource "google_compute_instance" "marketplace_dev" {
  name         = "marketplace-dev"
  machine_type = "e2-micro"
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
    cost-center = "002-01"
    env         = "dev"
  }
}

resource "google_compute_instance" "finance_dev" {
  name         = "finance-dev"
  machine_type = "e2-micro"
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
    team        = "finance"
    cost-center = "002-02"
    env         = "dev"
  }
}
