variable "function_app_names" {
  type = list(string)
  default = [
    "func-lab-sof-01",
    "func-lab-sof-02",
    "func-lab-sof-03"
  ]
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-lab-sof"
  os_type             = "Linux"
  sku_name            = "Y1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
}
resource "azurerm_linux_function_app" "func" {
  #count                      = length(var.function_app_names)
  count                      = var.env == "prod" ? 3 : 2
  name                       = var.function_app_names[count.index]
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id
  site_config {}
  tags = {
    Name = var.function_app_names[count.index]
  }
}
