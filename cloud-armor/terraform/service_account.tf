resource "google_service_account" "service_account" {
  account_id   = local.application_name
  display_name = "Service Account for instances of ${local.application_name}"
}

resource "google_project_iam_member" "log_writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "monitoring_writer" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.service_account.email}"
}
