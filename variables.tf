variable "cluster_name" {
    type = string
    description = "Cluster name"
}

variable "region" {
    type = string
    description = "Region"
}

variable "cluster_definition" {
    type = object({
      disk_size_gb = string,
      cluster_cidr = string,
      services_cidr = string
    })
}

variable "node_definition" {
    type = object({
      node_count = number,
      min_node_count = number,
      max_node_count = number,
      machine_type: string,
      disk_size_gb: number
    })
}

variable "project" {
  type = string
  description = "GCP Project"
}

variable "namespace" {
  type = string
  description = "Service Acccount namespace"
}

variable "service_account" {
  type = string
  description = "Service Account name"
}