variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Subnet address prefix"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  type        = string
}

variable "admin_username" {
  description = "Admin username"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}


variable "rg-name" {
  description = "resource group for VMs"
  type        = string
}

variable "rg-location" {
  description = "location of the resource group"
  type        = string
}
