variable "location" {
  # https://azuretracks.com/2021/04/current-azure-region-names-reference/
  default     = "switzerlandnorth"
  description = "Location of the resources"
}

resource "random_pet" "name_prefix" {
  prefix = "pgflex"
  length = 1
}

resource "azurerm_resource_group" "default" {
  name     = random_pet.name_prefix.id
  location = var.location
}
