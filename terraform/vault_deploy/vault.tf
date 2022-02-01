# Key de la storage account para el backend de vault
variable "vault_storage_key" {}

# Client ID del service principal que usamos para el unseal de vault
variable "keyvault_unseal_clientid" {}

# Secret/password del service principal que usamos para el unseal de vault
variable "keyvault_unseal_secret" {}

# Deploy de vault como un helm chart
resource "helm_release" "vault_deploy" {
  name  = "vault"
  chart = "../../vault_chart"
  set {
    name  = "server.affinity"
    value = ""
  }
  set {
    name  = "server.ha.replicas"
    value = "3"
  }
  set {
    name  = "server.ha.enabled"
    value = "true"
  }
  set {
    name  = "server.ha.config"
    value = <<EOT
      ui = true
      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "azure" {
        accountName  = "vaultbackendkeyrotation"
        accountKey   = "${var.vault_storage_key}"
        container    = "vault-container"
      }
      # service_registration "kubernetes" {}
      seal "azurekeyvault" {
        client_id      = "${var.keyvault_unseal_clientid}"
        client_secret  = "${var.keyvault_unseal_secret}"
        tenant_id      = "eaf2733b-9db9-4ce4-aa41-0e902bf3e5f9"
        vault_name     = "vaultunsealkvuni"
        key_name       = "vault-autounseal-key"
      }
    EOT
  }
}


