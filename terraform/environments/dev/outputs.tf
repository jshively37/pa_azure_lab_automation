output "ngfw_mgmt_fqdn" {
  value = "https://${azurerm_public_ip.mgmt_public.fqdn}"
}

output "ngfw_untrust_fqdn" {
  value = azurerm_public_ip.untrust_public.fqdn
}

output "ngfw_default_route" {
  value = "${cidrhost(local.untrust_subnet[0], 1)}/24"
}

output "panorama_mgmt_ip" {
  value = var.create_panorama ? local.panorama_mgmt_ip : null
}

output "jumpbox_windows_ip" {
  value = local.windows_ip
}

output "jumpbox_ubuntu_ip" {
  value = local.ubuntu_ip
}

output "ngfw_trust_address" {
  value = "${local.pa_trust_ip}/24"
}

output "ngfw_untrust_address" {
  value = "${local.pa_untrust_ip}/24"
}

output "ngfw_trust_interface" {
  value = "ethernet1/2"
}

output "ngfw_untrust_interface" {
  value = "ethernet1/1"
}

output "username" {
  value = var.user_name
}

output "password" {
  value     = var.password
  sensitive = false
}
