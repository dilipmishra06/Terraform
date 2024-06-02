core_infra_rg_name = "core-infra-rg"
core_infra_location = "eastus"

core_infra_vnet_name = "core-infra-vnet"
core_infra_vnet_address_space = [ "192.168.0.0/16" ]
core_infra_vnet_dns_servers = ["10.0.0.4","10.0.0.5"]
core_infra_ddos_name = "core-infra-ddos"

core_infra_subnet_list = {
  core-infra-subnet-1 = {
    cidr = ["192.168.1.0/24"]
  }
  core-infra-subnet-2 = {
    cidr = ["192.168.2.0/24"]
  }

}
nsg_list = {
  nsg1 = {
    nsg1_rule1 = {
      priority = 102
      direction = "Outbound"
      access = "Deny"
      protocol  = "*"
      source_port_range = "*"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
    nsg1_rule2 = {
      priority = 101
      direction = "Outbound"
      access = "Allow"
      protocol  = "*"
      source_port_range = "443"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefix = "Internet"
    }
  }
  nsg2 = {
    nsg2_rule1 = {
      priority = 103
      direction = "Outbound"
      access = "Deny"
      protocol  = "*"
      source_port_range = "*"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
    nsg2_rule2 = {
      priority = 102
      direction = "Inbound"
      access = "Allow"
      protocol  = "*"
      source_port_range = "80"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefix = "Internet"
    }
  }
}

subnet_nsg_map = {
  core-infra-subnet-1 = "nsg1"
  core-infra-subnet-2 = "nsg2"
}

tags = {
  env = "dev"
}
