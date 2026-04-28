provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

variable "app_name" {
  description = "Name of the web app"
  type        = string
}

resource "azurerm_resource_group" "rg" {
  name     = "app-rg"
  location = "southeastasia"
}

resource "azurerm_service_plan" "plan" {
  name                = "app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}
