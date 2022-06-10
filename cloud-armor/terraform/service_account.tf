resource "google_service_account" "service_account" {
  account_id   = var.application_name
  display_name = "Service Account for instances of ${local.application_name}"
}

resource "google_service_account_iam_member" "log_writer" {
  service_account_id = google_service_account.sa.name
  role               = "roles/logging.logWriter"
  member             = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_iam_member" "monitoring_writer" {
  service_account_id = google_service_account.sa.name
  role               = "roles/monitoring.metricWriter"
  member             = "serviceAccount:${google_service_account.service_account.email}"
}
