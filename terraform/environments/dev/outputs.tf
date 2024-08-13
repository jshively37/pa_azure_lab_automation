output "mgmt_ext_ip" {
  value = azurerm_public_ip.mgmt_public.ip_address
}

output "mgmt_ext_fqdn" {
  value = azurerm_public_ip.mgmt_public.fqdn
}

output "ipsec_tunnel_ext_ip" {
  value = azurerm_public_ip.untrust_public.ip_address
}

output "ipsec_tunnel_ext_fqdn" {
  value = azurerm_public_ip.untrust_public.fqdn
}

output "azure_untrust_gw" {
  value = cidrhost(local.untrust_subnet[0], 1)
}

output "panorama_mgmt_ip" {
  value = var.create_panorama ? local.panorama_mgmt_ip : null
}

output "windows_jumpbox_ip" {
  value = local.windows_ip
}

output "ubuntu_jumpbox_ip" {
  value = local.ubuntu_ip
}
