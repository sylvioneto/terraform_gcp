resource "google_compute_region_instance_group_manager" "instance_group" {
  name               = "${var.name}-group"
  region             = var.region
  base_instance_name = var.name

  version {
    instance_template = google_compute_instance_template.template.id
    name              = var.name
  }
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = var.name
  region = var.region
  target = google_compute_region_instance_group_manager.instance_group.self_link

  autoscaling_policy {
    min_replicas    = lookup(var.autoscaler_config, "min_replicas")
    max_replicas    = lookup(var.autoscaler_config, "max_replicas")
    cooldown_period = lookup(var.autoscaler_config, "cooldown_period")

    cpu_utilization {
      target = lookup(var.autoscaler_config, "cpu_target")
    }
  }
}
