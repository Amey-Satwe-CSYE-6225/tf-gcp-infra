terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
  }
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}


resource "google_service_account" "default" {
  account_id   = "test-gcf-sa"
  display_name = "Test Service Account"
}

resource "google_storage_bucket" "default" {
  name                        = "${random_id.bucket_prefix.hex}-gcf-source" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_crypto_key.bucket_key.name
  }
}
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_kms_crypto_key_iam_binding" "bucket_iam" {
  crypto_key_id = google_kms_crypto_key.sql_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
  ]
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "../serverless/"
}

resource "google_storage_bucket_object" "default" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path # Path to the zipped function source code

}

resource "google_cloudfunctions2_function" "default" {
  name        = "verify_email"
  location    = var.region
  description = "a new function"

  build_config {
    runtime     = "nodejs18"
    entry_point = "myCloudEventFunction" # Set the entry point
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.default.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    min_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      DATABASE = google_sql_database.main.name
      UNAME    = google_sql_user.db_user.name
      PASSWORD = random_password.DB_Password.result
      HOST     = google_sql_database_instance.main_primary.private_ip_address
      DOMAIN   = var.domain_name
    }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    vpc_connector                  = google_vpc_access_connector.vpcConnector.self_link
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.default.email
    vpc_connector_egress_settings  = "VPC_CONNECTOR_EGRESS_SETTINGS_UNSPECIFIED"
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = var.pubsub_topic
    retry_policy   = "RETRY_POLICY_RETRY"
  }
  depends_on = [google_pubsub_topic.verifyUser, google_sql_database.main]
}

resource "google_vpc_access_connector" "vpcConnector" {
  name          = "connector"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.cloud_demo_vpc.id
  machine_type  = "f1-micro"
}
