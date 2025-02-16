# Virtual Network & Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vm-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.rg-location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet" "subnet" {
  name                 = "vm-subnet"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Network Security Group (SSH allowed)
resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = var.rg-location
  resource_group_name = var.rg-name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = var.rg-location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-public-ip.id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}



resource "azurerm_public_ip" "vm-public-ip" {
  name                = "vm-public-ip"
  allocation_method   = "Static"
  location            = var.rg-location
  resource_group_name = var.rg-name

}


# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "test-vm"
  location            = var.rg-location
  resource_group_name = var.rg-name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}