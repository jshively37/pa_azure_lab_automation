resource "azurerm_resource_group" "rg" {
  name     = "${var.user_name}-${var.role}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vn" {
  name                = "${var.user_name}-${var.role}-vn"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  tags                = var.tags
}
