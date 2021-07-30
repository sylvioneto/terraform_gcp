
resource "google_compute_subnetwork" "ad_admin_subnet" {
  name          = "ad-admins"
  description   = "It hosts VMs used to connect with the Managed AD"
  network       = google_compute_network.ad_vpc.id
  ip_cidr_range = "10.0.2.0/24"
}

resource "google_compute_instance" "ad_admin_vm" {
  name         = "ad-admin"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["allow-ingress-from-iap"]
  shielded_instance_config {
    enable_secure_boot = true

  }

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2016-dc-v20210713"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.ad_admin_subnet.self_link
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
