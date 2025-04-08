# tflint-ignore: terraform_required_providers
resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content = <<EOF
    apiVersion: v1
    kind: Config
    current-context: ${var.cluster_name}
    preferences: {}
    clusters:
    - cluster:
        certificate-authority-data: ${google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate}
        server: https://${google_container_cluster.gke_cluster.endpoint}
      name: ${var.cluster_name}
    contexts:
    - context:
        cluster: ${var.cluster_name}
        user: ${var.cluster_name}
      name: ${var.cluster_name}
    users:
    - name: ${var.cluster_name}
      user:
        token: ${data.google_client_config.default.access_token}
EOF
}

# tflint-ignore: terraform_naming_convention
resource "kubernetes_namespace" "cnrm-system" {
  metadata {
    name = "cnrm-system"
    labels = {
      "configmanagement.gke.io/system" = "true"
    }
  }
}

# tflint-ignore: terraform_naming_convention
resource "kubernetes_namespace" "challenges-456002" {# tflint-ignore: terraform_required_providers

  metadata {
    name = "challenges-456002"
    annotations = {
      "cnrm.cloud.google.com/project-id" = var.project,
    }
  }
  
}