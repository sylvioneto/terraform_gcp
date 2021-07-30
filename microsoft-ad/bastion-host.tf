
resource "google_compute_subnetwork" "bastion_hosts" {
  name          = "bastion-hosts"
  description   = "It hosts VMs used to connect with the Managed AD"
  network       = google_compute_network.admin_vpc.id
  ip_cidr_range = "10.1.1.0/24"
}

resource "google_compute_instance" "ad_bastion_host" {
  name         = "ad-bastion-host"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2016"
    }
  }

  network_interface {
    # network = google_compute_network.admin_vpc.id
    subnetwork = google_compute_subnetwork.bastion_hosts.self_link

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    AD_DOMAIN = google_active_directory_domain.ad_domain.domain_name
  }

  service_account {
    email  = google_service_account.ad_bastion_host.email
    scopes = ["cloud-platform"]
  }
}

resource "google_service_account" "ad_bastion_host" {
  account_id   = "ad-bastion-host"
  display_name = "Microsoft AD Bastion Host Service Account"
}
