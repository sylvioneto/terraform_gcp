resource "google_service_account" "service_account" {
  account_id   = "gke-${var.name}"
  display_name = "GKE Cluste ${var.name}"
}

resource "google_project_iam_member" "storage" {
  role = "roles/storage.objectViewer"

  member = "serviceAccount:${google_service_account.service_account.name}"

}

resource "google_project_iam_member" "logging" {
  role = "roles/logging.logWriter"

  member = "serviceAccount:${google_service_account.service_account.name}"
}

resource "google_project_iam_member" "monitoring" {
  role = "roles/monitoring.admin"

  member = "serviceAccount:${google_service_account.service_account.name}"

}

resource "google_project_iam_member" "trace" {
  role = "roles/cloudtrace.admin"

  member = "serviceAccount:${google_service_account.service_account.name}"
}

resource "google_project_iam_member" "service_management" {
  role = "roles/servicemanagement.reporter"

  member = "serviceAccount:${google_service_account.service_account.name}"
}
