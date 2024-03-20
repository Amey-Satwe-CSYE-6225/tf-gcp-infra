resource "google_dns_record_set" "webapp" {
  name = var.dns_name
  type = var.dns_record_type
  ttl  = var.dns_ttl

  managed_zone = var.dns_managed_zone_id

  rrdatas = [google_compute_instance.default.network_interface[0].access_config[0].nat_ip]

  depends_on = [google_compute_instance.default]
}
