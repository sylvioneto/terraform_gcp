resource "google_compute_instance_template" "template" {
  name_prefix = "${var.name}-"
  description = var.description

  instance_description    = "Instance created from template - ${var.name}"
  machine_type            = var.machine_type
  metadata                = var.metadata
  metadata_startup_script = var.startup_script
  tags                    = var.network_tags

  labels = {
    terraform = "true"
    owner     = var.owner
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = data.google_compute_subnetwork.subnetwork.id
  }

  service_account {
    email  = local.service_account
    scopes = var.scopes
  }

  lifecycle {
    create_before_destroy = true
  }
}
