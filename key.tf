resource "random_string" "random_key" {
  length  = 4
  special = false
}
resource "google_kms_key_ring" "keyring" {
  name     = "keyringexample${random_string.random_key.id}"
  location = "us-east1"
}

resource "google_kms_crypto_key" "compute_key" {
  name            = "cryptokeyexample${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "sql_key" {
  name            = "sqlkey${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"
  purpose         = "ENCRYPT_DECRYPT"
  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "bucket_key" {
  name            = "bucketkey${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "secret_manager_key" {
  name            = "secretKey${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = false
  }
}
