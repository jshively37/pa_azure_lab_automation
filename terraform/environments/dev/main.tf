locals {
  subnets        = tolist(cidrsubnets(var.address_space[0], 2, 2, 2, 2))
  untrust_subnet = [local.subnets[0]]
  trust_subnet   = [local.subnets[1]]
  mgmt_subnet    = [local.subnets[3]]
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.user_name}-${var.role}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.user_name}-${var.role}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "untrust" {
  name                 = "untrust"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.untrust_subnet
}

resource "azurerm_subnet" "trust" {
  name                 = "trust"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.trust_subnet
}

resource "azurerm_subnet" "mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.mgmt_subnet
}
