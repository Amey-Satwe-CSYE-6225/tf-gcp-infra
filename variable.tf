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
