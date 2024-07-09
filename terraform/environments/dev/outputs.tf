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
