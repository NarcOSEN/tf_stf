
provider "azurerm" {
  features {}
  subscription_id = "fa299cc3-888f-48f9-99c9-183728b8ba29"
}



resource "azurerm_resource_group" "common-resource-group" {
  name     = "common-resource-group"
  location = "France Central"

}

module "vm" {
  #for_each = var.vm_instances

  source                = "./modules/vm"
  prefix                = var.prefix
  vm_size               = "Standard_B1s"
  admin_username        = "narcosen"
  vnet_address_space    = "10.20.1.0/24"
  subnet_address_prefix = "10.20.1.0/27"
  ssh_public_key_path   = "~/.ssh/id_rsa.pub"
  rg-location           = azurerm_resource_group.common-resource-group.location
  rg-name               = azurerm_resource_group.common-resource-group.name
}


module "vpngw" {
  source                = "./modules/vpngw"
  rg-location           = azurerm_resource_group.common-resource-group.location
  rg-name               = azurerm_resource_group.common-resource-group.name
  prefix                = var.prefix
  vnet_address_space    = "10.30.1.0/24"
  subnet_address_prefix = "10.30.1.0/27"
}



resource "azurerm_local_network_gateway" "hetzner-lgw" {
  name                = "hetzner-lgw"
  location            = azurerm_resource_group.common-resource-group.location
  resource_group_name = azurerm_resource_group.common-resource-group.name
  gateway_address     = "65.109.95.102"
  address_space       = ["10.1.1.0/24"]
}



resource "azurerm_virtual_network_gateway_connection" "cn-hetzner" {
  name                = "cn-hetzner"
  location            = azurerm_resource_group.common-resource-group.location
  resource_group_name = azurerm_resource_group.common-resource-group.name

  type                       = "IPsec"
  virtual_network_gateway_id = module.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.hetzner-lgw.id

  shared_key = "testkey"

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    pfs_group        = "ECP256"
    ipsec_integrity  = "SHA256"
  }
}






######Peering###########
###Need to add allow vnetgw usage config on peerings (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#use_remote_gateways-1) #########
resource "azurerm_virtual_network_peering" "vpngw-to-vm-peer" {
  name                      = "vpngw-to-vm-peer"
  resource_group_name       = azurerm_resource_group.common-resource-group.name
  virtual_network_name      = module.vpngw.vnet.name
  remote_virtual_network_id = module.vm.vnet.id
}

resource "azurerm_virtual_network_peering" "vm-to-vpngw-peer" {
  name                      = "vm-to-vpngw-peer"
  resource_group_name       = azurerm_resource_group.common-resource-group.name
  virtual_network_name      = module.vm.vnet.name
  remote_virtual_network_id = module.vpngw.vnet.id
}
