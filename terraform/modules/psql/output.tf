output "subnet_id" {
  description = "id of db subnet"
  value = azurerm_subnet.subnet.id
}

output "private_dns_zone_id" {
  description = "id of private dns zone of db"
  value = azurerm_private_dns_zone.private_dns_zone.id
}

output "psql_db" {
  description = "id of psql Flexible Server"
  value = azurerm_postgresql_flexible_server.psql.id
}

