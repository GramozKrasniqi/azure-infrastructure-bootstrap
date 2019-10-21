locals {
  resource_group_name = "aksrg-${var.environment}-${var.location}"
  aks_name = "aks-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "aksrg" {
    name     = local.resource_group_name
    location = var.location
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                      = local.aks_name
  location                  = var.location
  resource_group_name       = local.resource_group_name
  dns_prefix                = local.aks_name
  kubernetes_version        = "1.12.7" # az aks get-versions -l westeurope -o table

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_B2s"
    vnet_subnet_id  = var.vnet_cluster_subnet
  }

  role_based_access_control {
    azure_active_directory {
      server_app_id = var.server_app_id
      server_app_secret = var.server_app_secret
      client_app_id = var.client_app_id
    }
    enabled = true
  }

  network_profile {
      network_plugin = "azure"
      service_cidr   = "10.1.0.0/24"
      dns_service_ip = "10.1.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
  }

  service_principal {
    client_id     = var.cluster_sp_client_id
    client_secret = var.cluster_sp_client_secret
  }

  tags = {
    environment = var.environment
  }
}
