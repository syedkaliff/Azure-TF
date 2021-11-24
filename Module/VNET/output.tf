output "vnet_subnet_production_id" {
  value       = element(azurerm_subnet.example.*.id, 0)
  description = "VNET production subnet id "
  
  depends_on = [
    azurerm_subnet.example,
  ]
}

output "vnet_id" {
  value = azurerm_virtual_network.example.id
  description ="VNET ID"
}

output "cidr_block" {
  value       = azurerm_virtual_network.example.address_space
  description = "The CIDR block of the VNET"
}

output "vnet_name" {
  value = azurerm_virtual_network.example.name
  description ="VNET Name"
}

