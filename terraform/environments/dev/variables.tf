variable "address_space" {
  description = "List of subnets"
  type        = list(any)
  default     = ["10.32.0.0/22"]
}

variable "location" {
  description = "Region to deploy"
  type        = string
  default     = "eastus"
}

variable "create_panorama" {
  description = "Set to true in your tfvars file if you want to create a Panorama instance"
  type        = bool
  default     = false
}

variable "password" {
  description = "Password for all devices"
  type        = string
}

variable "user_name" {
  description = "Username for all devices"
  type        = string
}

variable "role" {
  description = "Type of connection"
  type        = string
  default     = "sc"
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_D8_v4"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    DND       = "true"
    no-delete = "true"
  }
}
