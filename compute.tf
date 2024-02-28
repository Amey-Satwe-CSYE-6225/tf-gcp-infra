resource "google_compute_instance" "default" {
  name         = var.compute_name
  machine_type = var.machine_type
  zone         = var.instance_zone

  tags = [var.compute_tag]
  boot_disk {
    initialize_params {
      image = var.custom_image_family
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
  network_interface {
    network    = var.vpc_name
    subnetwork = var.webapp_subnet_name
    access_config {
      network_tier = var.network_tier
    }
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
  fi
  EOT
  depends_on              = [google_compute_network.cloud_demo_vpc, google_compute_subnetwork.webapp]
}
