output "vnet_address_space" {
  value = module.vnet.vnet_address_space
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "dmz_subnets" {
  value = module.vnet.vnet_subnets.0
}

output "aks_subnets" {
  value = module.vnet.vnet_subnets.1
}