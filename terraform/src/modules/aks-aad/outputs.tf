output "cluster_sp_client_id" {
    value = azuread_application.cluster_app_registration.application_id
}
output "cluster_sp_client_secret" {
    value = azuread_service_principal_password.cluster_service_principal_password.value
} 

output "server_app_id" {
    value = azuread_application.server.application_id
}

output "server_app_secret" {
    value = azuread_service_principal_password.server.value
}

output "client_app_id" {
    value = azuread_application.client.application_id
}