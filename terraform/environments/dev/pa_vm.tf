# resource "random_password" "pa_admin_pwd" {
#   length = 12
#   special = true
# }

resource "azurerm_linux_virtual_machine" "pa_fw" {
  name                            = "${var.user_name}-${var.role}-fw"
  computer_name                   = "${var.user_name}-${var.role}-fw"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.user_name
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.mgmt.id,
    azurerm_network_interface.untrust.id,
    azurerm_network_interface.trust.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name      = "byol"
    publisher = "paloaltonetworks"
    product   = "vmseries-flex"
  }
  source_image_reference {
    offer     = "vmseries-flex"
    publisher = "paloaltonetworks"
    sku       = "byol"
    version   = "latest"
  }
  tags = var.tags
}
