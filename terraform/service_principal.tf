data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  display_name = "vault_unseal_spn"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "seviceprincipal" {
  application_id               = azuread_application.application.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}
