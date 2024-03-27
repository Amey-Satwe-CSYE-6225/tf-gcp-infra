resource "google_service_account" "csye-demo-service-account" {
  account_id                   = var.service_account_id
  display_name                 = var.display_name
  create_ignore_already_exists = true
}

resource "google_project_iam_binding" "logging_iam" {
  project = var.project_id
  role    = var.logging_role

  members = [
    "serviceAccount:${google_service_account.csye-demo-service-account.email}",
  ]
}

resource "google_project_iam_binding" "monitoring_iam" {
  project = var.project_id
  role    = var.monitoring_role

  members = [
    "serviceAccount:${google_service_account.csye-demo-service-account.email}",
  ]
}

resource "google_project_iam_binding" "pubsub_role" {
  project = var.project_id
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.csye-demo-service-account.email}",
  ]
}
