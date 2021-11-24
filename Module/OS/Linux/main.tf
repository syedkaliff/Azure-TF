resource "azurerm_resource_group" "example" {
    name  = "${var.rgname}-RG"
    location = var.location
}


resource "azurerm_network_interface" "example" {
  name                = upper("${var.hostname}-nic")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "${var.hostname}-ipconfig"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name              = upper(var.hostname)
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.size

  disable_password_authentication = false
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
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
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
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = count.index+10
  caching            = "ReadWrite"
}