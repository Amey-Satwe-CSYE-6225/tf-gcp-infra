resource "google_dns_record_set" "webapp" {
  name = var.dns_name
  type = var.dns_record_type
  ttl  = var.dns_ttl

  managed_zone = var.dns_managed_zone_id

  rrdatas = [google_compute_address.default.address]

  depends_on = [google_compute_address.default]
}
