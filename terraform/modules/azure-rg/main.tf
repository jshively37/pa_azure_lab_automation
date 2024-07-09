resource "azurerm_resource_group" "example" {
  name     = "${var.user_name}-${var.role}-rg"
  location = var.location
}
