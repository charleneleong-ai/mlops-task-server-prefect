output "acr_id" {
  description = "Acr Registry ID"
  value = azurerm_container_registry.acr.id
}


output "acr_login_server" {
  description = "Acr Login Server"
  value = azurerm_container_registry.acr.login_server
}


output "acr_admin_username" {
  description = "Acr Admin Username"
  value = azurerm_container_registry.acr.admin_username
}


output "acr_admin_password" {
  description = "Acr Admin Password"
  value = azurerm_container_registry.acr.admin_password
}