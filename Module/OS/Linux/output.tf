output "vmname" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "PrivateIPAddress" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "PublicIPAddress" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "rgoutput" {
  value = azurerm_linux_virtual_machine.vm.resource_group_name
}