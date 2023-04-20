provider "azurerm" {
    version = "2.5.0"
    features {}
}

resource "azurerm_resource_group" "resource_group" {
    name = "tfmainrg"
    location = "UK South"
}

resource "azurerm_container_group" "container_group" {
    name                  = "weatherapi"
    location              = azurerm_resource_group.resource_group.location
    resource_group_name   = azurerm_resource_group.resource_group.name

    ip_address_type     = "public"
    dns_name_label      = "benjaminadlardweatherapi"
    os_type             = "Linux"

    container {
        name            = "weatherapi"
        image           = "benjaminadlard/weatherapi"
            cpu         = "1"
            memory      = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
    }
}