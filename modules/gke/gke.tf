resource "google_container_cluster" "gke" {
  name     = var.name
  location = var.region

  default_max_pods_per_node = var.default_max_pods_per_node
  remove_default_node_pool  = var.remove_default_node_pool
  initial_node_count        = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  release_channel {
    channel = var.release_channel
  }

  // Network settings
  network    = var.vpc
  subnetwork = google_compute_subnetwork.gke_subnet.self_link
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.ip_allocation_ranges["master"]
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value["cidr_block"]
        display_name = cidr_blocks.value["display_name"]
      }
    }
  }

  // Nodes config
  node_config {
    service_account = google_service_account.service_account.email
    preemptible     = true
    machine_type    = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = local.labels
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
