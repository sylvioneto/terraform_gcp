resource "google_compute_instance_template" "template" {
  name_prefix = "${var.name}-"
  description = var.description

  instance_description    = "Instance created from template - ${var.name}"
  machine_type            = var.machine_type
  metadata                = var.metadata
  metadata_startup_script = var.startup_script
  tags                    = var.network_tags

  labels = var.labels

  scheduling {
    automatic_restart   = var.automatic_restart
    on_host_maintenance = var.on_host_maintenance
    preemptible         = var.preemptible
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
  }

  service_account {
    email  = local.service_account
    scopes = var.scopes
  }

  lifecycle {
    create_before_destroy = true
  }
}
