
terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
    version = "=1.28.0"
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    client_id = var.client_id
    client_secret = var.client_secret
}

module "vnet" {
    source = "./modules/vnet"
    environment = terraform.workspace
    location = var.location
}

module "aks_aad" {
    source = "./modules/aks-aad"
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    environment = terraform.workspace
    location = var.location
}

module "aks" {
    source = "./modules/aks"
    environment = terraform.workspace
    location = var.location
    cluster_sp_client_id = module.aks_aad.cluster_sp_client_id
    cluster_sp_client_secret = module.aks_aad.cluster_sp_client_secret
    server_app_id =  module.aks_aad.server_app_id
    server_app_secret =  module.aks_aad.server_app_secret
    client_app_id =  module.aks_aad.client_app_id
    vnet_cluster_subnet = module.vnet.aks_subnets
}