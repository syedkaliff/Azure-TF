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

module "vm" {
  source = "../../../module/os/windows"
  hostname = "pvlomsads"
  rgname = "pvlomsads"
  size = "standard_B1s"
  vnet = data.azurerm_virtual_network.dvnet.name
  subnet = data.azurerm_subnet.dsubnet.id
  username = "syed"
  password = "Pa55w0rd123!!!"
  vmdisks = ["8","4"]
  location = "eastus"
}

