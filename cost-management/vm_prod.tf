resource "google_compute_instance" "prod1" {
  name         = "vm-prod-001"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod.self_link
  }

  labels = {
    team        = "finance"
    cost-center = "003-04"
    env         = "prod"
  }
}

resource "google_compute_instance" "prod2" {
  name         = "vm-prod-002"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod.self_link
  }

  labels = {
    team        = "human-resources"
    cost-center = "003-03"
    env         = "prod"
  }
}

resource "google_compute_instance" "prod3" {
  name         = "vm-prod-003"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod.name
  }

  labels = {
    team        = "marteting"
    cost-center = "003-03"
    env         = "prod"
  }
}

