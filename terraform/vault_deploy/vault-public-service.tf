
resource "kubernetes_service" "public-service" {
  metadata {
    name = "vault-public-service"
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "vault"
      "app.kubernetes.io/name"     = "vault"
      "component"                  = "server"
    }
    port {
      port        = 80
      target_port = 8200
    }

    type = "LoadBalancer"
  }

  depends_on = [
    helm_release.vault_deploy
  ]
}
