
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = "=2.46.0"
      version = "~>2.0"
    }
  }
}

# data "azurerm_subscription" "current" {
# }

provider "azurerm" {
    features {}
    # subscription_id = data.azurerm_subscription.current.subscription_id
}

# terraform {
#     backend "azurerm" {
#         resource_group_name  = "charlene"
#         storage_account_name = "tfstate29688"
#         container_name       = "terraform"
#         key                  = "terraform.tfstate"
#     }
# }

terraform {
    backend "azurerm" {
        # resource_group_name  = "charlene"
        # storage_account_name = "tfstate1451"
        # container_name       = "terraform"
        # key                  = "terraform.tfstate"
    }
}


locals {
  # vnet_name = "k8s-vnet"
  vnet_name = "example-vn"
  tags = { "environment" = "test"
          "location"    = "australiaeast" }
}


resource "azurerm_resource_group" "k8srg" {
    name     = var.k8s_rg_name
    location = var.location
}

## Current subscription details
data "azurerm_subscription" "current" {
}


# ## VNET
# resource "azurerm_virtual_network" "vnet" {
#   name                = local.vnet_name
#   location            = azurerm_resource_group.k8srg.location
#   resource_group_name = azurerm_resource_group.k8srg.name
#   address_space       = ["10.0.0.0/16"]
# }

# ## External psql db 
# module "psql" {
#   source = "./modules/psql"
#   k8s_rg_name = azurerm_resource_group.k8srg.name
#   location = var.location
#   vnet_name = azurerm_virtual_network.vnet.name
#   vnet_id = azurerm_virtual_network.vnet.id
#   tags=local.tags
# }


# module "dns" {
#   source = "./modules/dns"

#   child_domain_resource_group_name = azurerm_resource_group.k8srg.name
#   child_domain_subscription_id     = data.azurerm_subscription.current.id
#   child_domain_prefix              = var.child_domain_prefix

#   parent_domain_resource_group_name = azurerm_resource_group.k8srg.name
#   parent_domain_subscription_id     =  data.azurerm_subscription.current.id
#   parent_domain                     = var.parent_domain
  
#   tags=local.tags
# }

module "k8s" {
  source = "./modules/k8s"
  k8s_rg = azurerm_resource_group.k8srg
  # dns_zone_id=module.dns.subscription_id
  location = var.location
  tags=local.tags
}
