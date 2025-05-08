resource "azurerm_windows_virtual_machine" "windows_jumpbox" {
  name                              = "${local.slug_name}-windows"
  computer_name                     = "windows-jumpbox"
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  size                              = "Standard_Ds3_v2"
  admin_username                    = var.user_name
  admin_password                    = var.password
  network_interface_ids             = [azurerm_network_interface.windows.id]
  vm_agent_platform_updates_enabled = false
  patch_mode                        = "AutomaticByPlatform"

  os_disk {
    name                 = "${local.slug_name}-windows-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.ubuntu_boot_diag.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "microsoftwindowsserver"
    offer     = "windowsserver"
    sku       = "2022-datacenter-azure-edition-hotpatch"
    version   = "latest"
  }
}
