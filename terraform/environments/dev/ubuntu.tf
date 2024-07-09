resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "${var.user_name}-${var.role}-ubuntu"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ubuntu.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "${var.user_name}-${var.role}-ubuntu-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "${var.user_name}-${var.role}-ubuntu"
  admin_username                  = var.user_name
  admin_password                  = var.password
  disable_password_authentication = false
  tags                            = var.tags
}
