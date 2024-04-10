
resource "google_sql_database_instance" "main_primary" {
  name                = random_string.DB_INSTANCE_NAME.id
  database_version    = var.database_version
  depends_on          = [google_service_networking_connection.private_vpc_connection, google_compute_network.cloud_demo_vpc, google_kms_crypto_key_iam_binding.sql_iam, google_project_service_identity.gcp_sa_cloud_sql]
  region              = var.region
  encryption_key_name = google_kms_crypto_key.sql_key.id
  settings {
    tier                        = var.database_tier
    availability_type           = var.database_availability
    disk_size                   = var.database_disk_size
    disk_type                   = var.database_disk_type
    deletion_protection_enabled = false
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.cloud_demo_vpc.id
      enable_private_path_for_google_cloud_services = true
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "main" {
  name     = var.database_name
  instance = google_sql_database_instance.main_primary.name
}

resource "google_sql_user" "db_user" {
  name     = var.sql_user
  instance = google_sql_database_instance.main_primary.name
  password = random_password.DB_Password.result
}

resource "random_password" "DB_Password" {
  length  = 8
  special = false
}

resource "random_string" "DB_INSTANCE_NAME" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = false
}


resource "google_compute_global_address" "private_ip_block" {
  name          = var.gloabal_ip_name
  purpose       = var.global_ip_purpose
  address_type  = var.global_ip_address_type
  ip_version    = var.global_ip_version
  prefix_length = var.global_ip_prefix_length
  network       = google_compute_network.cloud_demo_vpc.name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.cloud_demo_vpc.name
  service                 = var.service_networking_api_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
  depends_on              = [google_compute_global_address.private_ip_block]
  deletion_policy         = var.service_networking_deletion_policy
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key_iam_binding" "sql_iam" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.sql_key.id
  role          = var.encrypter_decrypter_role

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}
