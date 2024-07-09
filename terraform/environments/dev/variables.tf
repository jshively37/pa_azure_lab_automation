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

variable "password" {
  description = "Palo Alto admin password"
  type        = string
}

variable "user_name" {
  description = "Name of the user"
  type        = string
}

variable "role" {
  # WIP: Should be a list and loop through to deploy both a SC and RN infra
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
