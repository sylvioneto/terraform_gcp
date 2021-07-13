resource "google_compute_node_template" "soletenant_tmpl" {
  name      = "soletenant-template"
  region    = "us-central1"
  node_type = "n1-node-96-624"
}

resource "google_compute_node_group" "soletenant_grp" {
  name        = "soletenant-group"
  zone        = "us-central1-f"
  description = "Sole-tenant nodes to host Windows VMs"

  size          = 1
  node_template = google_compute_node_template.soletenant_tmpl.id
}
