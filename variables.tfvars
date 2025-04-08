cluster_definition = {
  cluster_cidr  = "/16"
  services_cidr = "/24"
}

cluster_name = "gke-cluster"
region       = "northamerica-south1-a"
project      = "challenges-456002"
service_account = "challengesa"

node_definition = {
  machine_type = "e2-standard-2"
  disk_size_gb = 20
  node_count   = 3
}