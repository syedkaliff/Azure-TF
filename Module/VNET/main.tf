resource "azurerm_resource_group" "example" {
    name  = var.rgname
    location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = var.vnetname
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  count = length(var.address_subnets)
  #name                 = "testsubnet-${count.index+1}"
  name = var.subnetnames[count.index]
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [element( var.address_subnets,count.index)]
}