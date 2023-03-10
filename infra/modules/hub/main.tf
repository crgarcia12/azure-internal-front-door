resource "azurerm_resource_group" "hub_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

module "hub_vnet" {
  source              = "./vnet"
  prefix              = var.prefix
  location            = var.location
  ip_second_octet     = "200"
  resource_group_name = azurerm_resource_group.hub_rg.name
}

module "hub_vm" {
  source              = "./vm"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  subnet_id           = module.hub_vnet.vnet_vm_subnet_id
}

module "hub_ars" {
  source              = "./routeserver"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  subnet_id           = module.hub_vnet.vnet_ars_subnet_id
}

module "hub_fw" {
  source              = "./firewall"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  subnet_id           = module.hub_vnet.vnet_fw_subnet_id
}