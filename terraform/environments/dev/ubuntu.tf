resource "random_id" "random_id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "ubuntu_boot_diag" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  # name                  = "${local.slug_name}-ubuntu"
  name                  = "${local.slug_name}-ubuntu"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ubuntu.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "${local.slug_name}-ubuntu-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.ubuntu_boot_diag.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "${local.slug_name}-ubuntu"
  admin_username                  = var.user_name
  admin_password                  = var.password
  disable_password_authentication = false
  tags                            = var.tags
}
