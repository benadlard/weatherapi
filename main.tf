provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "storage-rg"
        storage_account_name = "benadlardtfstorage"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

# resource groups
resource "azurerm_resource_group" "main-rg" {
    name = "main-rg"
    location = "UK South"
}

# container resource
resource "azurerm_container_group" "container-group" {
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