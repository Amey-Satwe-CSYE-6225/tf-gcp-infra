
resource "google_compute_region_health_check" "health-check" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    request_path = "/healthz"
    port         = "3000"
  }
}


resource "google_compute_region_instance_group_manager" "webappServer" {
  name = "webapp-manager"

  base_instance_name        = "webapp"
  region                    = var.region
  distribution_policy_zones = var.dist_policy_zones

  version {
    instance_template = google_compute_region_instance_template.instance_template.self_link
  }

  named_port {
    name = "http"
    port = 3000
  }

  auto_healing_policies {
    health_check      = google_compute_region_health_check.health-check.id
    initial_delay_sec = 300
  }
}



resource "google_compute_region_autoscaler" "autoScaler" {
  name   = "my-region-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.webappServer.id

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 15
    cpu_utilization {
      target = 0.05
    }
  }
}
