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

resource "azurerm_resource_group" "storage-rg" {
    name     = "storage-rg"
    location = "UK South"
}

# storage container groups

resource "azurerm_storage_account" "tfstate-sa" {
    name                     = "benadlardtfstorage"
    resource_group_name      = azurerm_resource_group.storage-rg.name
    location                 = azurerm_resource_group.storage-rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate-container" {
    name                  = "tfstate"
    storage_account_name  = azurerm_storage_account.tfstate-sa.name
    container_access_type = "private"
}

# container resource
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