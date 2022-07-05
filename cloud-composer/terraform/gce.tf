resource "google_service_account" "mssql" {
  account_id   = "mssql-service-account"
  display_name = "MSSQL 2019 on GCE"
}

resource "google_compute_instance" "mssql" {
  name         = "mssql-2019"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-b"
  labels       = local.resource_labels
  tags         = ["allow-rdp"]

  boot_disk {
    initialize_params {
      image = "windows-sql-cloud/sql-2019-standard-windows-2022-dc-v20220624"
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = "gce-databases"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.mssql.email
    scopes = ["cloud-platform"]
  }
}
