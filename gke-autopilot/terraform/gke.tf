resource "google_container_cluster" "primary" {
  name             = local.cluster_name
  location         = var.region
  resource_labels  = local.resource_labels
  enable_autopilot = true

  release_channel {
    channel = "STABLE"
  }

  # networking
  network    = module.vpc.network_name
  subnetwork = local.cluster_name
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  // whitelist who can reach cluster's master nodes
  // NOTE: internet is not recommended! It is used for testing only.
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "internet"
      cidr_block   = "0.0.0.0/0"
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = local.cluster_ip_ranges.master
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  depends_on = [
    module.vpc
  ]
}
