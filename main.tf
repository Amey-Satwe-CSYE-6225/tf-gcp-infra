resource "google_compute_network" "cloud_demo_vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  name          = var.webapp_subnet_name
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.cloud_demo_vpc.name
}

resource "google_compute_subnetwork" "db" {
  name          = var.db_subnet_name
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.cloud_demo_vpc.name
}

resource "google_compute_route" "webapp_route" {
  name             = var.webapp_route_name
  network          = google_compute_network.cloud_demo_vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}

