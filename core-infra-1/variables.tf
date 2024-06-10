variable "core_infra_rg_name" {
  type = string
  description = "Resource Group name of Core Infra"
  default = "core_infra_rg"
}

variable "core_infra_location" {
  type = string
  description = "Core Infra Resource Group Location"
  default = "east-us"
}

variable "core_infra_vnet_name" {
  type = string
  description = "Core Infra Vnet name"
  default = "core_vnet"
}

variable "core_infra_vnet_address_space" {
  type = list(string)
  description = "Core Infra Vnet address space"
  default = [ "192.168.0.0/16" ] 
}

variable "core_infra_vnet_dns_servers" {
  type = list(string)
  description = "Core Infra Vnet dns servers"
  default = []
  
}

variable "core_infra_ddos_name" {
  type = string
  description = "Core Infra Vnet ddos plan name"
  default = "core_infra_vnet_ddos"
}

variable "core_infra_subnet_list" {
  type = map
  description = "List of subnets in core infra vnet"
}

variable "nsg_list" {
  type = map
  description = "List of nsgs for core infra subnets" 
}

variable "subnet_nsg_map" {
  type = map
  description = "Subnet to NSG association map"  
}

variable "tags" {
  type = map
  description = "Tags for Core Infra resources"
}