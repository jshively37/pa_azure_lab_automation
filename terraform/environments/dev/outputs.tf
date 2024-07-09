# output "subnets" {
#   value = local.subnets
# }

# output "untrust_subnet" {
#   value = local.untrust_subnet
# }

# output "trust_subnet" {
#   value = local.trust_subnet
# }

# output "mgmt_subnet" {
#   value = local.mgmt_subnet
# }

output "mgmt_ip" {
  value = azurerm_public_ip.mgmt_public.ip_address
}

output "mgmt_fqdn" {
  value = azurerm_public_ip.mgmt_public.fqdn
}

output "untrust_ip" {
  value = azurerm_public_ip.untrust_public.ip_address
}

output "untrust_fqdn" {
  value = azurerm_public_ip.untrust_public.fqdn
}
