terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
      #version = "~> 2.0"             
      #version = ">= 2.0.0, < 2.60.0"
      #version = ">= 2.0.0, <= 2.64.0"   
      #version = "~> 2.64" # For Production grade              
    }
  }
}
# Provider Block
provider "azurerm" {
features {}
}
data "azurerm_resource_group" "drgname" {
  name = "test"

}
data "azurerm_virtual_network" "dvnet" {
  name = "Prod-VNET"
  resource_group_name = data.azurerm_resource_group.drgname.name
}

data "azurerm_subnet" "dsubnet" {
  resource_group_name = data.azurerm_resource_group.drgname.name
  virtual_network_name = data.azurerm_virtual_network.dvnet.name
  name ="sub1"
  
}

locals {

    rules = {
    rdp_from_onprem = {
      priority         = 100
      protocol         = "TCP"
      destination_port = "3389"
      source_address   = "10.0.0.0/8"
      access           = "Deny"
    }

    winrm_from_onprem = {
      priority         = 110
      destination_port = "5985-5986"
      source_address   = "10.0.0.0/8"
      access           = "Allow"
    }

    dynatrace_security_gateway = {
      priority         = 120
      destination_port = "9999"
      access           = "Deny"
    }
    test_nsg_rule = {
      priority         = 345
      destination_port = "3389"
      source_address   = "8.8.8.8/32"
      access           = "Deny"
    }

  }

tags = {
    "Owner"      = "user"
    Environment = "dev"
  }
}



module "nsg" {
  source = "../../../Module/nsg"
  for_each                    = local.rules
  nsg_name                    = join("-",[module.vm.vmname,"NSG"])
  name                        = "allow-${each.key}-in"
  direction                   = "Inbound"
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = lookup(each.value, "protocol", "*")
  source_port_range           = "*"
  destination_port_range      = lookup(each.value, "destination_port", "*")
  source_address_prefix       = lookup(each.value, "source_address", "*")
  destination_address_prefix  = lookup(each.value, "destination_address", "*")
  #resource_group_name         = data.azurerm_resource_group.drgname.name
  resource_group_name = module.vm.rgname
  #network_security_group_name = "azurerm_network_security_group.nsg.name"
  location = module.vm.location
  nicid = module.vm.nic-id
  
  tags = local.tags
}


module "vm" {
  source = "../../../module/os/windows"
  hostname = "pvlomsads"
  rgname = "pvlomsads"
  size = "standard_B1ms"
  vnet = data.azurerm_virtual_network.dvnet.name
  subnet = data.azurerm_subnet.dsubnet.id
  username = "syed"
  password = "Pa55w0rd123!!!"
  vmdisks = ["8","4"]
  location = "eastus"
 pip = false
  
  tags = local.tags
}