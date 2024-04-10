data "google_project" "project" {}

resource "google_kms_crypto_key_iam_member" "kms-secret-binding" {
  crypto_key_id = google_kms_crypto_key.secret_manager_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-secretmanager.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret" "secret-with-automatic-cmek" {
  secret_id = "webapp_secret"

  replication {
    auto {
      customer_managed_encryption {
        kms_key_name = "kms-key"
      }
    }
  }

  depends_on = [google_kms_crypto_key_iam_member.kms-secret-binding]
}

resource "google_secret_manager_secret_version" "webapp_secret_version" {
  secret = google_secret_manager_secret.secret-with-automatic-cmek.id

  secret_data = jsonencode({
    DATABASE = google_sql_database.main.name
    UNAME    = google_sql_user.db_user.name
    PASSWORD = random_password.DB_Password.result
    HOST     = google_sql_database_instance.main_primary.private_ip_address
  })
}
