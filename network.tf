resource "azurerm_virtual_network" "pommy_vnet" {
    name = "vnet-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    location = var.location
    address_space = ["10.0.0.0/16"]

    tags = var.tags

}

resource "azurerm_subnet" "subnetdb" {
    name = "subnet-db-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    virtual_network_name = azurerm_virtual_network.pommy_vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetapp" {
    name = "subnet-app-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    virtual_network_name = azurerm_virtual_network.pommy_vnet.name
    address_prefixes = ["10.0.2.0/24"]
}