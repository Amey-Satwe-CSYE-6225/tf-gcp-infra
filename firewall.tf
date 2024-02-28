resource "google_compute_firewall" "firewall_rules" {
  project     = var.project_id
  name        = var.firewall_name
  network     = var.vpc_name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = var.firewall_ports
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.compute_tag]
  depends_on    = [google_compute_network.cloud_demo_vpc, google_compute_subnetwork.webapp]
}
