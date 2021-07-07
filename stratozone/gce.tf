locals {
  labels = {
    owner   = "sylvio"
    purpose = "training"
  }
}

resource "google_compute_instance" "app_server_win" {
  name         = "app-server-001"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    network = google_compute_subnetwork.subnet.name
  }
}


resource "google_compute_instance" "db_server_linux" {
  name         = "db-server-001"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_subnetwork.subnet.name
  }

}


resource "google_compute_instance" "stratozone_collector" {
  name         = "stratozone-collector"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["allow-iap", "stratozone"]
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    network = google_compute_subnetwork.subnet.name
  }
}
