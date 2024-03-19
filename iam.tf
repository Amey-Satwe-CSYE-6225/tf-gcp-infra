resource "google_service_account" "csye-demo-service-account" {
  account_id                   = "csye-demo-service-account"
  display_name                 = "VM Monitor Service Acc"
  create_ignore_already_exists = true
}

resource "google_project_iam_binding" "logging_iam" {
  project = var.project_id
  role    = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.csye-demo-service-account.email}",
  ]
}

resource "google_project_iam_binding" "monitoring_iam" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.csye-demo-service-account.email}",
  ]
}
