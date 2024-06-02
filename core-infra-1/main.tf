terraform {
  required_providers {
   azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
   backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstateazureterraform"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  
}


module "Core-Infrastructure" {
  source = "../modules/CoreInfra"
  core_infra_ddos_name = var.core_infra_ddos_name
  core_infra_location = var.core_infra_location
  core_infra_rg_name = var.core_infra_rg_name
  core_infra_subnet_list = var.core_infra_subnet_list
  core_infra_vnet_address_space = var.core_infra_vnet_address_space
  core_infra_vnet_dns_servers =  var.core_infra_vnet_dns_servers
  core_infra_vnet_name = var.core_infra_vnet_name
  nsg_list = var.nsg_list
  subnet_nsg_map = var.subnet_nsg_map
  tags = var.tags
}