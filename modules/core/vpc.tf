# Create a VPC and Firewall rules
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  description             = "VPC managed by terraform"
  auto_create_subnetworks = false
}
