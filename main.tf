provider "azurerm" {
    features{}
}

resource "azurerm_resource_group" "pommy_rg" {
    name = "rg-${var.project}-${var.environment}"
    location = var.location
    tags = var.tags
}