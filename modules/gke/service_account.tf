resource "google_service_account" "service_account" {
  account_id   = "gke-${var.region}-${var.name}"
  display_name = "GKE Cluster ${var.name}"
}

resource "google_project_iam_member" "role" {
  count      = length(var.iam_roles)
  role       = var.iam_roles[count.index]
  member     = "serviceAccount:${google_service_account.service_account.name}"
  depends_on = [google_service_account.service_account.name]
}
