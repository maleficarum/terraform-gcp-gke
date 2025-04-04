  terraform {
    required_version = ">=1.9.7"
    required_providers {

      google = {
        source  = "hashicorp/google"
        version = "~> 6.28.0"
      }

    }
  }

  provider "google" {
    project     = "challenges-455322"
    region      = "northamerica-south1"
  }  

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}  

resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  enable_shielded_nodes    = "true"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  //disk_size_gb             = var.cluster_definition.disk_size_gb

  release_channel {
    channel = "STABLE"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_definition.cluster_cidr
    services_ipv4_cidr_block =  var.cluster_definition.services_cidr
  }

  timeouts {
    create = "20m"
    update = "20m"
  }

  lifecycle {
    ignore_changes = [node_pool]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.node_definition.min_node_count
    max_node_count = var.node_definition.max_node_count
  }

  timeouts {
    create = "20m"
    update = "20m"
  }

  node_config {
    preemptible  = true
    machine_type = var.node_definition.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

data "kubernetes_all_namespaces" "all" {
    
}