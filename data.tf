data "azurerm_resource_group" "rg" {
  name = "rg-sp1-t--azu-formation-terraform-octobre26-txt"
}

data "azurerm_subnet" "subnet" {
  name                 = "subnet-lab2"
  virtual_network_name = "vnet-lab2"
  resource_group_name  = data.azurerm_resource_group.rg.name
}
