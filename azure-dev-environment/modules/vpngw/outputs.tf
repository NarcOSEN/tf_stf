output "public_ip" {
  value = azurerm_public_ip.vpngw-pip.ip_address
}

output "id" {
  value = azurerm_virtual_network_gateway.vpngw.id
}

output "vnet" {
  value = azurerm_virtual_network.vpngw-vnet
}