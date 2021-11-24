  variable "name" { }                
  variable "direction"   { }        
  variable "access" {}
  variable "priority" {}
  variable "protocol" {}
  variable "source_port_range" {}
  variable "destination_port_range" {}
  variable "source_address_prefix" {}
  variable "destination_address_prefix" {}
  variable "resource_group_name" {}
 # variable "network_security_group_name" {}
  variable "nsg_name" {  }

  variable "tags" { }
  variable "location" {} 
 variable "nicid" {}
  #variable "nsgid" {}
  variable "vm-nsg" {
    type = bool
    default = true
  }