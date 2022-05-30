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


module "vm" {
  source = "../Module/OS/Linux"
  hostname = "pvlomsads"
  rgname = "pvlomsads"
  size = "standard_B1s"
  vnet =module.vnet.vnet_id
  subnet =module.vnet.vnet_subnet_production_id
  username = "syed"
  password = "Pa55w0rd123!!!"
  vmdisks = ["4","8"]
  location = "eastus"
}



module "vnet" {
    #for_each = var.vms

   # count = var.subnetnames
    source = "../Module/VNET"
    rgname = "test"
    address_space = ["10.0.0.0/8"]
    address_subnets = ["10.0.1.0/24","10.0.2.0/24"]
    vnetname = "Prod-VNET"
    location = "eastus"
    subnetnames = ["sub1","wub2"]

}
