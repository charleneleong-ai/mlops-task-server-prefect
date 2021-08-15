resource "azurerm_subnet" "subnet" {
  name                 = "${var.vnet_name}_subnet"
  resource_group_name  = var.k8s_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "psql.postgres.database.azure.com"
  resource_group_name = var.k8s_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_link" {
  name                  = "psqlvnet.com"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.k8s_rg_name
}

resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = "psqlflexibleserver"
  resource_group_name    = var.k8s_rg_name
  location               = var.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  administrator_login    = "psqladminun"
  administrator_password = "H@Sh1CoR3!"

  storage_mb = 32768

  sku_name   = "GP_Standard_D4s_v3"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_link]
  tags = var.tags
}