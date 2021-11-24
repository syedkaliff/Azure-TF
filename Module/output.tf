
output "vnet-address" {
    description     =   "Print the vnet-address(taking from vnet output)"
    value           =   module.vnet.cidr_block
}

output "multiple" {
    value = {
        "vnet_id" = module.vnet.vnet_id
        "vnet_name" = module.vnet.vnet_name
        "VMName" = module.vm.vmname
        "PrivateIP" = module.vm.PublicIPAddress
      "RGname" =module.vm.rgoutput
            
        
    }
  
}