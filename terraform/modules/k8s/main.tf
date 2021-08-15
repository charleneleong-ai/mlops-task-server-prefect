# resource "azurerm_resource_group" "k8s" {
#     name     = var.resource_group_name
#     location = var.location
# }

data "azurerm_resource_group" "k8srg" {
    name = var.k8s_rg.name
}
resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = data.azurerm_resource_group.k8srg.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = data.azurerm_resource_group.k8srg.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

# data "azurerm_role_definition" "contributor" {
#   name = "Contributor"
# }

# resource "azurerm_user_assigned_identity" "aks_identity" {
#   name                = "aks-identity"
#   resource_group_name = data.azurerm_resource_group.k8srg.name
#   location            = data.azurerm_resource_group.k8srg.location
# }

# resource "azurerm_role_assignment" "aks_role" {
#   scope                = var.dns_zone_id
#   role_definition_name = "DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
# }


resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = data.azurerm_resource_group.k8srg.location
    resource_group_name = data.azurerm_resource_group.k8srg.name
    dns_prefix          = var.dns_prefix

    # private_cluster_enabled = true
    # private_dns_zone_id     = var.private_dns_zone_id

    identity {
        type = "SystemAssigned"
        # type = "UserAssigned"
        # user_assigned_identity_id=azurerm_user_assigned_identity.aks_identity.id
    }

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2_v3"
        type            = "VirtualMachineScaleSets"
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
        }
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = var.tags

#     depends_on = [
#     azurerm_role_assignment.aks_role,
#   ]
}