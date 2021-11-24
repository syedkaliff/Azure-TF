



resource "azurerm_network_security_rule" "allow-in" {
  #for_each                    = local.rules
  name                        = var.name
  direction                   = var.direction
  access                      = var.access
  priority                    = var.priority
  protocol                    = var.protocol
  source_port_range           = var.source_port_range
  destination_port_range      = var.destination_port_range
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  
}


resource "azurerm_network_security_group" "nsg" {
  count = !var.vm-nsg ? 0:1
  name                = var.nsg_name
  #resource_group_name = azurerm_resource_group.rg.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "nsg-attach" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  network_interface_id = var.nicid
  #depends_on = [azurerm_network_security_group.nsg]
  }

