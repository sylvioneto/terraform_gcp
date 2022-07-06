resource "google_compute_instance" "mssql_client" {
  name                      = "mssql-client"
  machine_type              = "e2-small"
  zone                      = "${var.region}-b"
  labels                    = local.resource_labels
  tags                      = ["allow-ssh"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220701"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = local.composer_env_name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<EOF
#!/bin/sh
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo dpkg --configure -a
apt-get update
env ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
echo 'PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/profile
  EOF

  depends_on = [
    module.vpc
  ]

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.mssql.email
    scopes = ["cloud-platform"]
  }
}

resource "google_service_account" "mssql" {
  account_id   = "mssql-client-sa"
  display_name = "MSSQL Client VM"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.mssql.email}"
}

resource "google_project_iam_member" "monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.mssql.email}"
}
