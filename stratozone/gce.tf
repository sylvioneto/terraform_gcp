locals {
  labels = {
    owner   = "sylvio"
    purpose = "stratozone"
  }
}

resource "google_compute_instance" "app_server_win" {
  name         = "app-server-001"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  labels       = local.labels
  tags         = ["allow-rdp-ext"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral public IP
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  shielded_instance_config {
    enable_secure_boot = true
  }
}


resource "google_compute_instance" "db_server_linux" {
  name         = "db-server-001"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral public IP
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }
}


resource "google_compute_instance" "stratozone_collector" {
  name         = "stratozone-collector"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a"
  labels       = local.labels
  tags         = ["stratozone", "allow-rdp-ext"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link

    access_config {
      // Ephemeral public IP
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  shielded_instance_config {
    enable_secure_boot = true
  }
}
