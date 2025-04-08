resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  enable_shielded_nodes    = "true"
  remove_default_node_pool = false
  initial_node_count       = var.node_definition.node_count
  deletion_protection      = false

  release_channel {
    channel = "STABLE"
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  addons_config {
    config_connector_config {
      enabled = true
    }

    http_load_balancing {
      disabled = false
    }
  }

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_definition.cluster_cidr
    services_ipv4_cidr_block = var.cluster_definition.services_cidr
  }

  timeouts {
    create = "20m"
    update = "20m"
  }

  lifecycle {
    ignore_changes = [node_pool]
  }

  node_config {
    disk_size_gb    = var.node_definition.disk_size_gb
    machine_type    = var.node_definition.machine_type
    preemptible     = true
    service_account = google_service_account.gsa.email


    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only", # For public images
      # Add if using private images:
      # "https://www.googleapis.com/auth/devstorage.read_write",        
    ]
  }
}


provider "kubernetes" {
  host  = "https://${google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}

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
  project = var.project
  region  = "northamerica-south1"
}


/*
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = var.node_definition.node_count

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
*/