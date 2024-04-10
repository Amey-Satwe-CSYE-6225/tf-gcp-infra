resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only-subnet"
  ip_cidr_range = var.proxy_ip_cidr_range
  network       = google_compute_network.cloud_demo_vpc.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  region        = var.region
  role          = "ACTIVE"
}

resource "google_compute_firewall" "default" {
  name = "fw-allow-health-check"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.cloud_demo_vpc.id
  priority      = 1000
  source_ranges = var.firewall_generic_source_ranges
  target_tags   = var.target_tags_backend
}

resource "google_compute_address" "default" {
  name         = "webapp-ip"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_region_backend_service" "default" {
  name                  = "backend-service"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.health-check.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  port_name             = "http"
  backend {
    group           = google_compute_region_instance_group_manager.webappServer.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0

  }
}

resource "google_compute_region_url_map" "default" {
  name            = "regional-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_https_proxy" "default" {
  name             = "load-balancer-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.default.id
  ssl_certificates = [google_compute_region_ssl_certificate.ssl_cert.id]
}

resource "google_compute_region_ssl_certificate" "ssl_cert" {
  region      = var.region
  name        = "namecheap-certificate"
  private_key = file(var.key_file)
  certificate = file(var.cert_file)
}

resource "google_compute_forwarding_rule" "default" {
  name       = "forwarding-rule"
  depends_on = [google_compute_subnetwork.proxy_only]
  region     = var.region

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = var.frontend_port
  target                = google_compute_region_target_https_proxy.default.id
  network               = google_compute_network.cloud_demo_vpc.id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}
