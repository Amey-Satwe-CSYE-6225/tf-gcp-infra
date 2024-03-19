resource "google_dns_record_set" "webapp" {
  name = "ameysatwe.me."
  type = "A"
  ttl  = 300

  managed_zone = "cloud-demo-zone"

  rrdatas = [google_compute_instance.default.network_interface[0].access_config[0].nat_ip]

  depends_on = [google_compute_instance.default]
}
