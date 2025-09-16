terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.0"
    }
  }
  backend "azurerm" {
    # these have been created manually
    container_name       = "azure-terraform-playground"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# variable "resource_group_name" {
#   type        = string
#   description = "Name of the resource group"
#   default     = "land-of-the-vms"
# }

# variable "location" {
#   type        = string
#   description = "Azure region for resources"
#   # https://azuretracks.com/2021/04/current-azure-region-names-reference/
#   default     = "eastus"
# }

# variable "vm_name" {
#   type        = string
#   description = "Name of the virtual machine"
#   default     = "example-vm"
# }

# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.vm_name}-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = "${var.vm_name}-subnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_network_interface" "nic" {
#   name                = "${var.vm_name}-nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                  = var.vm_name
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   size                  = "Standard_B1s"
#   admin_username        = "azureadmin"
#   admin_password        = "P@ssw0rd1234!"
#   disable_password_authentication = false

#   network_interface_ids = [
#     azurerm_network_interface.nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
# }
variable "name_prefix" {
  default     = "pgflex"
  description = "Prefix of the resource name."
}

variable "location" {
  default     = "switzerlandnorth"
  description = "Location of the resource."
}
resource "random_pet" "name_prefix" {
  prefix = var.name_prefix
  length = 1
}

resource "azurerm_resource_group" "default" {
  name     = random_pet.name_prefix.id
  location = var.location
}

resource "random_password" "pass" {
  length = 20
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                   = "${random_pet.name_prefix.id}-server"
  resource_group_name    = azurerm_resource_group.default.name
  location               = azurerm_resource_group.default.location
  version                = "16"
  administrator_login    = "pgadmin"
  administrator_password = random_password.pass.result
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"  # Small Burstable tier
  public_network_access_enabled = true  # Enable public access
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "${random_pet.name_prefix.id}-db"
  server_id = azurerm_postgresql_flexible_server.default.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.default.fqdn
}

output "admin_password" {
  value     = random_password.pass.result
  sensitive = true
}