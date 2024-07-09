output "subnets" {
  value = local.subnets
}

output "untrust_subnet" {
  value = local.untrust_subnet
}

output "trust_subnet" {
  value = local.trust_subnet
}

output "mgmt_subnet" {
  value = local.mgmt_subnet
}

output "public_ip" {
  value = azurerm_public_ip.mgmt_public.ip_address
}
