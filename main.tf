#Dwie sieci (jedna hub, jedna spoke)
#W każdej sieci dwa subnety
#W każdej sieci dwie maszyny wirtualne

#Define Azure Provider
provider "azurerm" {
  version = "1.31.0"
}
resource "azurerm_resource_group" "RG" {
  name     = "${var.rg_name}"
  location = "WestEurope"

  tags = {
    environment = ",Workshop"
  }
}

###### VNET and Subnets #######
### SPOKE ###
resource "azurerm_virtual_network" "Vnet_Spoke" {
  name                = "${var.vnet_spoke_name}"
  location            = "${azurerm_resource_group.RG.location}"
  address_space       = "${var.address_space_spoke}"
  dns_servers         = "${var.dns_servers_spoke}"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  depends_on          = ["azurerm_resource_group.RG"]
}
resource "azurerm_subnet" "spoke1_subnet" {
  name                 = "${var.subnet1_spoke_name}"
  resource_group_name  = "${azurerm_resource_group.RG.name}"
  virtual_network_name = "${azurerm_virtual_network.Vnet_Spoke.name}"
  address_prefix       = "${var.spoke_subnet1_preffix}"
}
resource "azurerm_subnet" "spoke2_subnet" {
  name                 = "${var.subnet2_spoke_name}"
  resource_group_name  = "${azurerm_resource_group.RG.name}"
  virtual_network_name = "${azurerm_virtual_network.Vnet_Spoke.name}"
  address_prefix       = "${var.spoke_subnet2_preffix}"
}


### HUB ###

resource "azurerm_virtual_network" "Vnet_Hub" {
  name                = "${var.vnet_hub_name}"
  location            = "${azurerm_resource_group.RG.location}"
  address_space       = "${var.address_space_hub}"
  dns_servers         = "${var.dns_servers_hub}"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  depends_on          = ["azurerm_resource_group.RG"]
}

resource "azurerm_subnet" "hub1_subnet" {
  name                 = "${var.subnet1_hub_name}"
  resource_group_name  = "${azurerm_resource_group.RG.name}"
  virtual_network_name = "${azurerm_virtual_network.Vnet_Hub.name}"
  address_prefix       = "${var.hub_subnet1_preffix}"
}

resource "azurerm_subnet" "hub2_subnet" {
  name                 = "${var.subnet2_hub_name}"
  resource_group_name  = "${azurerm_resource_group.RG.name}"
  virtual_network_name = "${azurerm_virtual_network.Vnet_Hub.name}"
  address_prefix       = "${var.hub_subnet2_preffix}"
}

#### VM ####

resource "azurerm_network_interface" "nic1" {

  name                    = "${var.vm1_name}-nic"
  location                = "${azurerm_resource_group.RG.location}"
  resource_group_name     = "${azurerm_resource_group.RG.name}"
  internal_dns_name_label = "${var.vm1_name}"

  ip_configuration {
    name                          = "primary"
    subnet_id                     = "${azurerm_subnet.spoke1_subnet.id}"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_virtual_machine" "VM1" {
  name                          = "${var.vm1_name}-vm"
  location                      = "${azurerm_resource_group.RG.location}"
  resource_group_name           = "${azurerm_resource_group.RG.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic1.id}"]
  vm_size                       = "Standard_DS2_V2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm1_name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.vm1_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  storage_data_disk {
    name              = "${var.vm1_name}-datadisk1"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "128"
    lun               = "1"
    managed_disk_type = "StandardSSD_LRS"

  }

}
resource "azurerm_virtual_machine" "VM2" {
  name                          = "${var.vm2_name}-vm"
  location                      = "${azurerm_resource_group.RG.location}"
  resource_group_name           = "${azurerm_resource_group.RG.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic1.id}"]
  vm_size                       = "Standard_DS2_V2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm2_name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.vm2_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  storage_data_disk {
    name              = "${var.vm2_name}-datadisk1"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "128"
    lun               = "1"
    managed_disk_type = "StandardSSD_LRS"

  }

}
resource "azurerm_network_interface" "nic2" {

  name                    = "${var.vm2_name}-nic"
  location                = "${azurerm_resource_group.RG.location}"
  resource_group_name     = "${azurerm_resource_group.RG.name}"
  internal_dns_name_label = "${var.vm2_name}"

  ip_configuration {
    name                          = "primary"
    subnet_id                     = "${azurerm_subnet.hub1_subnet.id}"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_virtual_machine" "VM3" {
  name                          = "${var.vm3_name}-vm"
  location                      = "${azurerm_resource_group.RG.location}"
  resource_group_name           = "${azurerm_resource_group.RG.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic2.id}"]
  vm_size                       = "Standard_DS2_V2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm3_name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.vm3_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  storage_data_disk {
    name              = "${var.vm3_name}-datadisk1"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "128"
    lun               = "1"
    managed_disk_type = "StandardSSD_LRS"

  }

}
resource "azurerm_virtual_machine" "VM4" {
  name                          = "${var.vm4_name}-vm"
  location                      = "${azurerm_resource_group.RG.location}"
  resource_group_name           = "${azurerm_resource_group.RG.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic2.id}"]
  vm_size                       = "Standard_DS2_V2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm4_name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.vm4_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  storage_data_disk {
    name              = "${var.vm4_name}-datadisk1"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "128"
    lun               = "1"
    managed_disk_type = "StandardSSD_LRS"

  }

}
