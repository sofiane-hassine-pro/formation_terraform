# map of maps for creating containers
variable "container_map" {
  type = map(any)
  default = {
    container-1-sof = {
      access_type = "private"
    }
    container-2-sof = {
      access_type = "container"
    }
    container-3-sof-renamed = {
      access_type = "blob"
    }

  }
}
resource "azurerm_storage_container" "containers" {
  for_each              = var.container_map
  name                  = each.key
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = each.value["access_type"]
  depends_on = [
    azurerm_storage_account.sa
  ]
}
