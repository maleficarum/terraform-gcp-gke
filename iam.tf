resource "google_service_account" "gsa" {
  account_id   = var.service_account
  display_name = "Namespace Challenge Service Account"
  project = var.project
}

resource "null_resource" "gcloud_create" {
  provisioner "local-exec" {
    command = "./resources/gcloud.sh"
    when = create

    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
      action = "create"
    }
  }

  depends_on = [ kubernetes_namespace.challenges-456002 ]
}

resource "null_resource" "gcloud_destroy" {
  provisioner "local-exec" {
    command = "./resources/gcloud.sh"
    when = destroy

    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
      action = "destroy"
    }
  }

  depends_on = [ kubernetes_namespace.challenges-456002 ]
}