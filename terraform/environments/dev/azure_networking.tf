locals {
  subnets        = tolist(cidrsubnets(var.address_space[0], 2, 2, 2, 2))
  untrust_subnet = [local.subnets[0]]
  trust_subnet   = [local.subnets[1]]
  mgmt_subnet    = [local.subnets[3]]
  pa_untrust_ip  = cidrhost(local.untrust_subnet[0], 4)
  pa_trust_ip    = cidrhost(local.trust_subnet[0], 4)
  pa_mgmt_ip     = cidrhost(local.mgmt_subnet[0], 4)
  windows_ip     = cidrhost(local.trust_subnet[0], 10)
  ubuntu_ip      = cidrhost(local.trust_subnet[0], 20)
  slug_name      = "${var.user_name}-${var.location}-${var.role}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.slug_name}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.slug_name}-vnet"
  location            = azurerm_resource_group.rg.location
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
  name                = "${local.slug_name}-pa-mgmt-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  domain_name_label   = "${var.user_name}-${var.role}-mgmt"
  tags                = var.tags
}

resource "azurerm_public_ip" "untrust_public" {
  name                = "${local.slug_name}-pa-untrust-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  domain_name_label   = "${var.user_name}-${var.role}-untrust"
  tags                = var.tags
}

resource "azurerm_network_interface" "mgmt" {
  name                = "${local.slug_name}-pa-mgmt"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "mgmt"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.pa_mgmt_ip
    public_ip_address_id          = azurerm_public_ip.mgmt_public.id
  }
  tags = var.tags
}

resource "azurerm_network_interface" "untrust" {
  name                = "${local.slug_name}-pa-untrust"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "untrust"
    subnet_id                     = azurerm_subnet.untrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.pa_untrust_ip
    public_ip_address_id          = azurerm_public_ip.untrust_public.id
  }
  tags = var.tags
}

resource "azurerm_network_interface" "trust" {
  name                = "${local.slug_name}-pa-trust"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "trust"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.pa_trust_ip
  }
  tags = var.tags
}

resource "azurerm_network_interface" "ubuntu" {
  name                = "${local.slug_name}-ubuntu-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ubuntu"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ubuntu_ip
  }
}

resource "azurerm_route_table" "trust_route" {
  name                = "${local.slug_name}-trust-route-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "trust-to-pa"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.32.1.4"
  }
  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "trust_subnet" {
  subnet_id      = azurerm_subnet.trust.id
  route_table_id = azurerm_route_table.trust_route.id
}

resource "azurerm_network_security_group" "allow_all" {
  name                = "${local.slug_name}-sg-all"
  location            = azurerm_resource_group.rg.location
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
  tags = var.tags
}
