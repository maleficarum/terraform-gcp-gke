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
      min_node_count = number,
      max_node_count = number,
      machine_type: string
    })
}