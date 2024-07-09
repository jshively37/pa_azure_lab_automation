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

resource "azurerm_public_ip" "mgmt_public" {
  name                = "${var.user_name}-${var.role}-mgmt-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  # domain_name_label = "${var.location}.cloudapp.azure.com"
}

resource "azurerm_public_ip" "untrust_public" {
  name                = "${var.user_name}-${var.role}-untrust-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "mgmt" {
  name                = "${var.user_name}-${var.role}-mgmt-eth0"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "mgmt"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id =  azurerm_public_ip.mgmt_public.id
  }
}

resource "azurerm_network_interface" "untrust" {
  name                = "${var.user_name}-${var.role}-untrust-eth0"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "untrust"
    subnet_id                     = azurerm_subnet.untrust.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id =  azurerm_public_ip.untrust_public.id
  }
}

resource "azurerm_network_interface" "trust" {
  name                = "${var.user_name}-${var.role}-trust-eth0"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "trust"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_route_table" "trust_route" {
  name                = "${var.user_name}-${var.role}-trust-route-table"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name           = "trust-to-pa"
    address_prefix = azurerm_subnet.trust.address_prefixes[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.32.1.4"
  }
}

resource "azurerm_subnet_route_table_association" "trust_subnet" {
  subnet_id      = azurerm_subnet.trust.id
  route_table_id = azurerm_route_table.trust_route.id
}

resource "azurerm_network_security_group" "allow_all" {
  name                = "${var.user_name}-${var.role}-sg-all"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_All_In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow_All_Out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
