resource "azurerm_resource_group" "core_infra_rg" {
  name = var.core_infra_rg_name
  location = var.core_infra_location
  
}

resource "azurerm_network_ddos_protection_plan" "core_infra_ddos_protection" {
  name = var.core_infra_ddos_name
  location = var.core_infra_location
  resource_group_name = var.core_infra_rg_name
  tags = var.tags
  depends_on = [ azurerm_resource_group.core_infra_rg ]
  
}

resource "azurerm_virtual_network" "core_vnet" {
  name = var.core_infra_vnet_name
  location = var.core_infra_location
  resource_group_name = var.core_infra_rg_name
  address_space = var.core_infra_vnet_address_space
  dns_servers = var.core_infra_vnet_dns_servers

  ddos_protection_plan {
    id = azurerm_network_ddos_protection_plan.core_infra_ddos_protection.id
    enable = true
  }

  tags = var.tags
  depends_on = [ azurerm_resource_group.core_infra_rg ]
  
}

resource "azurerm_network_security_group" "core_infra_nsg" {

  for_each = var.nsg_list
  name = each.key
  location = var.core_infra_location
  resource_group_name = var.core_infra_rg_name
  tags = var.tags
  depends_on = [ azurerm_resource_group.core_infra_rg]

}

locals {
   nsg_local_list = flatten([for nsg_name, rules in var.nsg_list:
                      flatten([for rule_name, atrributes in rules:
                      {
                        nsg_rule = rule_name
                        priority = atrributes.priority
                        direction = atrributes.direction
                        access = atrributes.access
                        protocol  = atrributes.protocol
                        source_port_range = atrributes.source_port_range
                        destination_port_range = atrributes.destination_port_range
                        source_address_prefix = atrributes.source_address_prefix
                        destination_address_prefix = atrributes.destination_address_prefix
                        resource_group_name = var.core_infra_rg_name
                        network_security_group_name = nsg_name
                      }])

 ])
}

resource "azurerm_network_security_rule" "core_infra_nsg_rules" {

  for_each = { for index, record in local.nsg_local_list : index => record }

  name = each.value.nsg_rule
  priority = each.value.priority
  direction = each.value.direction
  access = each.value.access
  protocol = each.value.protocol
  source_port_range = each.value.source_port_range
  destination_port_range = each.value.destination_port_range
  source_address_prefix = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name = var.core_infra_rg_name
  network_security_group_name = each.value.network_security_group_name
  depends_on = [ azurerm_network_security_group.core_infra_nsg ]

}

resource "azurerm_subnet" "core_infra_subnets" {
  for_each = var.core_infra_subnet_list
  resource_group_name = var.core_infra_rg_name
  name = each.key
  address_prefixes = each.value.cidr
  virtual_network_name = var.core_infra_vnet_name
  depends_on = [ azurerm_virtual_network.core_vnet, azurerm_network_security_group.core_infra_nsg, azurerm_network_security_rule.core_infra_nsg_rules ]
}

resource "azurerm_subnet_network_security_group_association" "core_infra_subnet_nsg_association" {
   for_each = var.subnet_nsg_map
   subnet_id = azurerm_subnet.core_infra_subnets[each.key].id
   network_security_group_id = azurerm_network_security_group.core_infra_nsg[each.value].id
   depends_on = [ azurerm_subnet.core_infra_subnets, azurerm_network_security_group.core_infra_nsg ]
}