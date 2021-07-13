resource "google_service_account" "windows" {
  account_id   = "windows"
  display_name = "Service Account used in Windows Server VMs"
}

resource "google_compute_instance" "app1" {
  name         = "srv-app-001"
  machine_type = "n1-standard-2"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = google_service_account.windows.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    node_affinities {
      key      = "compute.googleapis.com/node-group-name"
      operator = "IN"
      values   = [google_compute_node_group.soletenant_grp.name]
    }
  }
}

resource "google_compute_instance" "app2" {
  name         = "srv-app-002"
  machine_type = "n1-standard-2"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210608"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = google_service_account.windows.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    node_affinities {
      key      = "compute.googleapis.com/node-group-name"
      operator = "IN"
      values   = [google_compute_node_group.soletenant_grp.name]
    }
  }
}

resource "google_compute_instance" "db1" {
  name         = "srv-db-001"
  machine_type = "n1-standard-4"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "windows-sql-cloud/sql-2016-standard-windows-2016-dc-v20210608"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = google_service_account.windows.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    node_affinities {
      key      = "compute.googleapis.com/node-group-name"
      operator = "IN"
      values   = [google_compute_node_group.soletenant_grp.name]
    }
  }
}
