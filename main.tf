provider "azurerm" {
    features{}
}

resource "azurerm_resource_group" "pommy_rg_test" {
    name = "rg-pommy-dev"
    location = "East US 2"
    tags = {
        environment = "dev"
        project = "pommy"
        created_by = "terraform"
    }
}