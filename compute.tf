resource "google_compute_instance" "default" {
  name         = var.compute_name
  machine_type = var.machine_type
  zone         = var.instance_zone

  tags = [var.compute_tag]

  boot_disk {
    initialize_params {
      image = var.custom_image_family
      size  = var.boot_disk_size
    }
  }
  network_interface {
    network    = var.vpc_name
    subnetwork = var.webapp_subnet_name
    access_config {
      network_tier = "STANDARD"
    }
  }
  depends_on = [google_compute_network.cloud_demo_vpc, google_compute_subnetwork.webapp]
}
