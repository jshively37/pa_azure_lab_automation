output "mgmt_ext_ip" {
  value = azurerm_public_ip.mgmt_public.ip_address
}

output "mgmt_ext_fqdn" {
  value = azurerm_public_ip.mgmt_public.fqdn
}

output "untrust_ext_ip" {
  value = azurerm_public_ip.untrust_public.ip_address
}

output "untrust_ext_fqdn" {
  value = azurerm_public_ip.untrust_public.fqdn
}

output "untrust_gw" {
  value = cidrhost(local.untrust_subnet[0], 1)
}
