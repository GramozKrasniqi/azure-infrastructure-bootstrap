locals {
    aks_name = "aks-${var.environment}-${var.location}"
}

provider "azuread" {
    version = "=0.6.0"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
}

######################################################################### Cluster SP

resource "azuread_application" "cluster_app_registration" {
    name                       = local.aks_name
    homepage                   = "https://${local.aks_name}"
    identifier_uris            = ["https://${local.aks_name}-uri"]
    reply_urls                 = ["https://replyurl"]
    available_to_other_tenants = false
}

resource "azuread_service_principal" "cluster_service_principal" {
    application_id = azuread_application.cluster_app_registration.application_id
}

resource "azuread_service_principal_password" "cluster_service_principal_password" {
    service_principal_id = azuread_service_principal.cluster_service_principal.id
    value                = random_string.aks_password.result
    end_date             = timeadd(timestamp(), "87600h") # 10 years

    lifecycle {
        ignore_changes = ["end_date"]
    }
}

resource "random_string" "aks_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.cluster_service_principal.id
  }
}

######################################################################### Server App

resource "azuread_application" "server" {
  name                    = "${local.aks_name}-server"
  reply_urls              = ["http://${local.aks_name}-server"]
  type                    = "webapp/api"
  group_membership_claims = "All"

  required_resource_access {
    # Windows Azure Active Directory API
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      # DELEGATED PERMISSIONS: "Sign in and read user profile":
      # 311a71cc-e848-46a1-bdf8-97ff7156d8e6
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }

  required_resource_access {
    # MicrosoftGraph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }

    # DELEGATED PERMISSIONS: "Sign in and read user profile":
    # e1fe6dd8-ba31-4d61-89e7-88639da4683d
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    # DELEGATED PERMISSIONS: "Read directory data":
    # 06da0dbc-49e2-44d2-8312-53f166ab848a
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }
  }

  ##Currently not allowed with sp
  #provisioner "local-exec" {
    #command = "az ad app permission admin-consent --id ${azuread_application.server.application_id}"
  #}
}

resource "azuread_service_principal" "server" {
  application_id = azuread_application.server.application_id
}

resource "azuread_service_principal_password" "server" {
  service_principal_id = azuread_service_principal.server.id
  value                = random_string.application_server_password.result
  end_date             = timeadd(timestamp(), "87600h") # 10 years

  # The end date will change at each run (terraform apply), causing a new password to 
  # be set. So we ignore changes on this field in the resource lifecyle to avoid this
  # behaviour.
  # If the desired behaviour is to change the end date, then the resource must be
  # manually tainted.
  lifecycle {
    ignore_changes = ["end_date"]
  }
}

resource "random_string" "application_server_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.server.id
  }
}

######################################################################### Client App

resource "azuread_application" "client" {
  name       = "${local.aks_name}-client"
  reply_urls = ["http://${local.aks_name}-client"]
  type       = "native"

  required_resource_access {
    # Windows Azure Active Directory API
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      # DELEGATED PERMISSIONS: "Sign in and read user profile":
      # 311a71cc-e848-46a1-bdf8-97ff7156d8e6
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }

  required_resource_access {
    # AKS ad application server
    resource_app_id = "${azuread_application.server.application_id}"

    resource_access {
      # Server app Oauth2 permissions id
      id   = "${lookup(azuread_application.server.oauth2_permissions[0], "id")}"
      type = "Scope"
    }
  }

  ###Currently not allowed with service principal
  #provisioner "local-exec" {
    #command = "az ad app permission admin-consent --id ${azuread_application.client.application_id}"
  #}
}

resource "azuread_service_principal" "client" {
  application_id = azuread_application.client.application_id
}

resource "azuread_service_principal_password" "client" {
  service_principal_id = azuread_service_principal.client.id
  value                = random_string.application_client_password.result
  end_date             = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = ["end_date"]
  }
}

resource "random_string" "application_client_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.client.id
  }
}
