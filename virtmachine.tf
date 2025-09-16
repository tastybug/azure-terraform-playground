variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
  default     = "example-vm"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# fuer Java devs zu lesen wie:
# azurerm_linux_virtual_machine vm = new azurerm_linux_virtual_machine(..);

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.default.name
  location              = azurerm_resource_group.default.location
  size                  = "Standard_B1s"
  admin_username        = "azureadmin"
  admin_password        = "P@ssw0rd1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
