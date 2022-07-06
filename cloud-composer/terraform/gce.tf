resource "google_compute_instance" "default" {
  name         = "mssql-client"
  machine_type = "e2-small"
  zone         = "${var.region}-b"
  labels       = local.resource_labels
  tags         = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220701"
    }
  }

  network_interface {
    network = module.vpc.network_name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<EOF
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
  sudo apt-get update 
  sudo apt-get install mssql-tools unixodbc-dev -y
  sudo apt-get update 
  sudo apt-get install mssql-tools -y
  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
  source ~/.bashrc
  EOF

  depends_on = [
    module.vpc
  ]
}
