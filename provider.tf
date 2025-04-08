terraform {
  backend "gcs" {
    bucket = var.backend_bucket
  }
}

# tflint-ignore: terraform_required_providers
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
  region  = var.region
}