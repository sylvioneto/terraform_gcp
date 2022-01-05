resource "google_compute_instance" "marketplace_prod" {
  name         = "marketplace-prod"
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
    subnetwork = google_compute_subnetwork.prod.self_link
  }

  labels = {
    team        = "marketplace"
    cost-center = "001-01"
    env         = "prod"
  }
}

resource "google_compute_instance" "finance_prod" {
  name         = "finance-prod"
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
    subnetwork = google_compute_subnetwork.prod.self_link
  }

  labels = {
    team        = "payments"
    cost-center = "001-02"
    env         = "prod"
  }
}
