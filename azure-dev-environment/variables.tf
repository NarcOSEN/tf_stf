variable "vm_instances" {
  description = "VM configurations"
  type = map(object({
    location   = string
    vm_size    = string
    admin_user = string
  }))
  default = {
    "web" = {
      location   = "France Central"
      vm_size    = "Standard_B1s"
      admin_user = "narcosen"
    }
  }
}



variable "prefix" {
  default     = ""
  description = "Prefix used in global root module"

}