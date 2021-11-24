
output "vmname" {
  value = azurerm_windows_virtual_machine.vm.name
}

output "PrivateIPAddress" {
  value = azurerm_windows_virtual_machine.vm.private_ip_address
}

output "PublicIPAddress" {
  value = azurerm_windows_virtual_machine.vm.public_ip_address
}

output "location" {
  value = azurerm_windows_virtual_machine.vm.location
}

output "nic-id" {
    value = azurerm_network_interface.example.id
}

output "nic" {
    value = azurerm_network_interface.example.name
}

output "rgname" {
  value = azurerm_resource_group.example.name
}