data "google_compute_image" "my_image" {
  family = var.custom_image_family
}

resource "google_compute_region_instance_template" "instance_template" {
  name         = "webapp-template"
  machine_type = var.machine_type
  tags         = [var.compute_tag, "load-balanced-backend"]

  disk {
    source_image = data.google_compute_image.my_image.self_link
    auto_delete  = true
    boot         = true
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.compute_key
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.webapp_subnet_name
  }

  service_account {
    email  = google_service_account.csye-demo-service-account.email
    scopes = var.scopes
  }
  metadata_startup_script = <<-EOT
  #!/bin/bash
  file=/opt/webapp/.env
  if [ ! -f $file ]; then
    sudo touch $file
    sudo echo "DATABASE=${google_sql_database.main.name}" >> $file
    sudo echo "UNAME=${google_sql_user.db_user.name}" >> $file
    sudo echo "PASSWORD=${random_password.DB_Password.result}" >> $file
    sudo echo "HOST=${google_sql_database_instance.main_primary.private_ip_address}" >> $file
    sudo echo "ENVIRONMENT=PRODUCTION" >> $file
  fi
  EOT
  depends_on              = [google_compute_network.cloud_demo_vpc, google_compute_subnetwork.webapp, google_service_account.csye-demo-service-account]

}
