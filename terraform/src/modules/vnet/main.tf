locals {
    resource_group_name = "vnet-${terraform.workspace}-${var.location}"
}

resource "azurerm_resource_group" "aksrg" {
    name     = local.resource_group_name
    location = var.location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "1.2.0"
  location = var.location
  resource_group_name = local.resource_group_name
  address_space = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["dmz", "aks"]
  tags = {"environment": terraform.workspace}
}


