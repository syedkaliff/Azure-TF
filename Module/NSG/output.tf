output "nsgid" {
  value = azurerm_network_security_group.nsg.*.id
}

output "nsg-name" {
  value =azurerm_network_security_group.nsg.*.name
}