resource "azurerm_resource_group" "example" {
    name  = upper("${var.rgname}-RG")
    location = var.location
}


resource "azurerm_network_interface" "example" {
  name                = upper("${var.hostname}-nic")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name


  ip_configuration {
    name                          = upper("${var.hostname}-ipconfig")
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name              = upper(var.hostname)
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.size

  #disable_password_authentication = false
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    name =upper("${var.hostname}-OSDISK")
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

tags = merge (
     {hostname =var.hostname},
     var.tags
  )
}

resource "azurerm_managed_disk" "example" {
  count       = length(var.vmdisks)
  name        = upper("${var.hostname}-datadisk-${count.index+1}")
  location    = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb    = element(var.vmdisks, count.index)
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  count              = length(var.vmdisks)
  managed_disk_id    = element(azurerm_managed_disk.example.*.id, count.index)
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = count.index+10
  caching            = "ReadWrite"
}


  resource "azurerm_public_ip" "PIP" {
    count = var.pip ==true ?1:0
    name                = upper("${var.hostname}-PublicIP")
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    allocation_method   = "Static"
  }
