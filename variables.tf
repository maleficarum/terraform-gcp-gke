variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "cluster_definition" {
  type = object({
    cluster_cidr  = string,
    services_cidr = string
  })
  description = "Cluster definition"
}

variable "node_definition" {
  type = object({
    disk_size_gb = number,
    machine_type : string,
    node_count = number
  })
  description = "Node definition"
}

variable "project" {
  type = string
  description = "Project ID"
}

variable "service_account" {
  type = string
  description = "Service Account"  
}

variable "backend_bucket" {
  type = string
  description = "Backend bucket name"
}