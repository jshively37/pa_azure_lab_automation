resource "azurerm_linux_virtual_machine" "panorama" {
  count                           = var.create_panorama ? 1 : 0
  name                            = "${local.slug_name}-panorama"
  computer_name                   = "${local.slug_name}-panorama"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.user_name
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.panorama[0].id
  ]
  os_disk {
    name                 = "${local.slug_name}-panorama-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name      = "byol"
    publisher = "paloaltonetworks"
    product   = "panorama"
  }
  source_image_reference {
    offer     = "panorama"
    publisher = "paloaltonetworks"
    sku       = "byol"
    version   = "latest"
  }
  tags = var.tags
}
