data "azuread_client_config" "current" {}

# App registration para el service principal para el unseal del vault
resource "azuread_application" "application_unseal" {
  display_name = "vault_unseal_spn"
  owners       = [data.azuread_client_config.current.object_id]
}

# Service principal para el unseal de vault
resource "azuread_service_principal" "seviceprincipal_unseal" {
  application_id               = azuread_application.application_unseal.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# App registration para el service principal para la rotacion de secrets
resource "azuread_application" "application_rotation" {
  display_name = "spn_para_rotar_secret"
  owners       = [data.azuread_client_config.current.object_id]
}

# Service principal para la rotacion de secrets

resource "azuread_service_principal" "seviceprincipal_rotation" {
  application_id               = azuread_application.application_rotation.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Password del service principal que usaremos para el unseal de vault
# Este valor se va a guardar como un secret en la keyvault que estamos generando en keyvault.tf

resource "azuread_service_principal_password" "seviceprincipal_unseal_password" {
  service_principal_id = azuread_service_principal.seviceprincipal_unseal.object_id
}
