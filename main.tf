# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = "sofiane1stlab1dev"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "sofiane-${var.env}-conteneur-fichiers"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_network_security_group" "nsg2" {
  name                = "nsg-lab2-sofiane"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-lab2-sofiane"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_network_security_group.nsg2]
}

resource "azurerm_linux_virtual_machine" "vm" {
  #count 0 va supprimer la/les vm existante(s)
  count                 = var.env == "prod" ? 1 : 0
  name                  = "vm-lab2-${var.env}-${count.index}-sofiane"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = var.location
  size                  = var.vm_sku
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

