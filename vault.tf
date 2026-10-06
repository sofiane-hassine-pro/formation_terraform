# retrieve Tenant ID
data "azurerm_client_config" "current" {}

# map of secrets
variable "secret_map" {
  type = map(string)
  default = {
    db-password = "secretDbPwd!"
    api-key     = "sk-xxxxxxx"
  }
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-lab10-sof"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id       = azurerm_key_vault.kv.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secret_map
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
  lifecycle {
    #dit à Terraform : « ne tiens pas compte des différences sur l'attribut value ». Si la valeur réelle dans Azure diffère de celle de ton code, Terraform ne proposera pas de la modifier.
    ignore_changes = [value]
    #prevent_destroy = true : equivalent à azure lock, sécurité pour que ça ne soit pas supprimé
    prevent_destroy = false
  }
}

