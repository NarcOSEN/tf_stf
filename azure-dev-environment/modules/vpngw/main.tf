
resource "azurerm_virtual_network" "vpngw-vnet" {
  name                = "vpngw${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.rg-name
  address_space       = [var.vnet_address_space]
}


resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "vpngw${var.prefix}"
  location            = var.rg-location
  resource_group_name = var.rg-name
  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "GatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpngw-subnet.id
  }
}



resource "azurerm_subnet" "vpngw-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vpngw-vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_public_ip" "vpngw-pip" {
  name                = "vpngw${var.prefix}-pip"
  location            = var.rg-location
  resource_group_name = var.rg-name

  allocation_method = "Static"
}


