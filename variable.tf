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
