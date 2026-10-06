output "affichage_variables" {
  value = {
    var_env         = var.env
    var_tags_incomplete = var.tags_incomplete
    local_tags        = local.tags
        local_name        = local.tags.Name
  }
}


#output "vm_id" {
#  value       = azurerm_linux_virtual_machine.vm[0].id
#  description = "The ID of the Virtual Machine"
#}

output "nsg_name" {
  value       = azurerm_network_security_group.nsg2.name
  description = "The name of the Network Security Group"
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg2.id
  description = "The ID of the Network Security Group"
}
