variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "webapp_subnet_name" {
  type = string
}

variable "db_subnet_name" {
  type = string
}

variable "webapp_route_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "db_cidr_range" {
  type = string
}

variable "webapp_cidr_range" {
  type = string
}

variable "routing_mode" {
  type = string
}

variable "compute_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "instance_zone" {
  type = string
}

variable "compute_tag" {
  type = string
}

variable "custom_image_family" {
  type = string
}

variable "boot_disk_size" {
  type = number
}

variable "boot_disk_type" {
  type = string
}
variable "firewall_name" {
  type = string
}

variable "network_tier" {
  type = string
}

variable "sql_user" {
  type = string
}

variable "database_name" {
  type = string
}

variable "firewall_ports" {
  type = list(string)
}

variable "database_version" {
  type = string
}

variable "database_availability" {
  type = string
}

variable "database_disk_size" {
  type = number
}

variable "database_disk_type" {
  type = string
}

variable "database_tier" {
  type = string
}

variable "gloabal_ip_name" {
  type = string
}

variable "global_ip_purpose" {
  type = string
}

variable "global_ip_address_type" {
  type = string
}
variable "global_ip_version" {
  type = string
}
variable "global_ip_prefix_length" {
  type = number
}
variable "service_networking_api_service" {
  type = string
}
variable "service_networking_deletion_policy" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "dns_managed_zone_id" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "dns_record_type" {
  type = string
}

variable "dns_ttl" {
  type = number
}

variable "display_name" {
  type = string
}

variable "monitoring_role" {
  type = string
}

variable "logging_role" {
  type = string
}

variable "scopes" {
  type = list(string)
}

variable "domain_name" {
  type = string
}
variable "pubsub_topic" {
  type = string
}

variable "verify_schema" {
  type = string
}

variable "dist_policy_zones" {
  type = list(string)
}

variable "firewall_generic_source_ranges" {
  type = list(string)
}

variable "target_tags_backend" {
  type = list(string)
}

variable "proxy_ip_cidr_range" {
  type = string
}
