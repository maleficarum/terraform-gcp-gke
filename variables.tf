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
}

variable "node_definition" {
  type = object({
    disk_size_gb = number,
    machine_type : string,
    node_count = number
  })
}

variable "project" {
  type = string
  default = "Project ID"
}

variable "service_account" {
  type = string
  default = "Service Account"  
}