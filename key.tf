resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "us-east1"
}

resource "google_kms_crypto_key" "compute_key" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "sql_key" {
  name            = "sql_key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "bucket_key" {
  name            = "bucket_key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}
