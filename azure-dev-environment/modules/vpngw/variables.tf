variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "location" {
  description = "The region where the vpngw and its vnet will be deployed. Default France Central"
  default     = "France Central"
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


variable "rg-name" {
  description = "resource group for VMs"
  type        = string
}

variable "rg-location" {
  description = "location of the resource group"
  type        = string
}
