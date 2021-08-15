locals {
  acr_name = replace("${var.prefix}-${var.environment}-acr", "-", "")
  acr_rg_name = var.rg.name
  acr_location = var.rg.location
}

data "azurerm_resource_group" "acrrg" {
    name = local.acr_rg_name
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.acrrg.name
  location            = data.azurerm_resource_group.acrrg.location
  sku                 = "Premium"
  admin_enabled       = true

  identity {
    type= "SystemAssigned"
  }
  
}