
resource "azurerm_dns_zone" "child" {
  name                = "${lower(var.child_domain_prefix)}.${lower(var.parent_domain)}"
  resource_group_name = var.child_domain_resource_group_name
  tags                = var.tags
}

resource "azurerm_dns_ns_record" "child" {
  name                = lower(var.child_domain_prefix)
  zone_name           = lower(var.parent_domain)
  resource_group_name = var.parent_domain_resource_group_name
  ttl                 = 300
  tags                = var.tags

  records = azurerm_dns_zone.child.name_servers
}

# resource "azurerm_dns_a_record" "astronomer" {
#   name                = "astronomer"
#   zone_name           = azurerm_dns_zone.child.name
#   resource_group_name = var.child_domain_resource_group_name
#   ttl                 = 300
#   records             = [var.astronomer_load_balancer_external_ip]
# }