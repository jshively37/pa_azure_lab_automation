variable "user_name" {
  description = "Name of the user"
  type = string
}

variable "role" {
  # WIP: Should be a list and loop through to deploy both a SC and RN infra
  description = "Type of connection"
  type = string
  default = "sc"
}

variable "location" {
  description = "Region to deploy"
  type = string
  default = "US East"
}
