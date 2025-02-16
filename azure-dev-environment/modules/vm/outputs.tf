
output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "vm-public-ip" {
    value = azurerm_public_ip.vm-public-ip.ip_address
}