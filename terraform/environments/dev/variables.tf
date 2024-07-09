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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    DND       = "true"
    no-delete = "true"
  }
}
