# Input variable con el nombre del service principal que le vamos a rotar el password
variable "sp_Secret_Name" {}

# Obtenemos el service principal
data "azuread_service_principal" "spn_a_rotar" {
  display_name = var.sp_Secret_Name
}

# Generamos un nuevo password para el service principal
resource "azuread_service_principal_password" "spn_a_rotar_secret" {
  service_principal_id = data.azuread_service_principal.spn_a_rotar.object_id
}

# Guardamos el nuevo password en vault
resource "vault_generic_secret" "sp_secret_update" {
  path = "secret/${var.sp_Secret_Name}"

  data_json = <<EOT
  {
    "secret": "${azuread_service_principal_password.spn_a_rotar_secret.value}"
  }
  EOT
}
