## Configure the Microsoft Azure Provider
## <https://www.terraform.io/docs/providers/azurerm/index.html>
terraform {
  backend "remote"   {
	  organization = "SapphireHealth"
	  
	  workspaces {
		  name = "LCMC_NonPrd"
	  }
	  
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  
}

###############Get existing data sources###############

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group>
data "azurerm_resource_group" "rg" {
  name     = "Epic-Nonprd"
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network>
data "azurerm_virtual_network" "vnet" {
  name                = "Epic-Internal-VNET"
  resource_group_name = "Epic-Internal"

}

###############Create shared VNET resources###############

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "wss_subnet" {
  name                 = "WSS"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.195.114.0/24"]
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hyperspace_subnet" {
  name                 = "Hyperspace"
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.195.112.0/24"]
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "wss_nsg" {
  name                 = "WSS-NSG"
  location             = data.azurerm_virtual_network.vnet.location
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  
  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "hyperspace_nsg" {
  name                 = "Hyperspace-NSG"
  location             = data.azurerm_virtual_network.vnet.location
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  
  security_rule {
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "wss_nsg_attach" {
  subnet_id                 = azurerm_subnet.wss_subnet.id
  network_security_group_id = azurerm_network_security_group.wss_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "hyperspace_nsg_attach" {
  subnet_id                 = azurerm_subnet.hyperspace_subnet.id
  network_security_group_id = azurerm_network_security_group.hyperspace_nsg.id
}

###############HSW###############
## Create an availability set
## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set>
resource "azurerm_availability_set" "hsw_aset" {
  name                = "${var.hsw_epicappname}_Nonprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hsw_subnet" {
  name                 = "HSW"
  resource_group_name  = "Epic-Internal"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.195.113.0/24"]
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "hsw_nic0" {
  name                = "${var.hsw_servername0}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hsw_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.hsw_ip_address0
  }
  
  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_network_interface" "hsw_nic1" {
  name                = "${var.hsw_servername1}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hsw_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.hsw_ip_address1
  }
  
  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "hsw_vm0" {
  name                = var.hsw_servername0
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.hsw_aset.id
  network_interface_ids = [
    azurerm_network_interface.hsw_nic0.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.hsw_servername0}_OSdisk"	
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_windows_virtual_machine" "hsw_vm1" {
  name                = var.hsw_servername1
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.hsw_aset.id
  network_interface_ids = [
    azurerm_network_interface.hsw_nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.hsw_servername1}_OSdisk"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "hsw_ddisk0" {
  name                          = "${var.hsw_servername0}_datadisk_0"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_managed_disk" "hsw_ddisk1" {
  name                          = "${var.hsw_servername1}_datadisk_1"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.hsw_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "hsw_ddiskattach0" {
  managed_disk_id    = azurerm_managed_disk.hsw_ddisk0.id
  virtual_machine_id = azurerm_windows_virtual_machine.hsw_vm0.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_virtual_machine_data_disk_attachment" "hsw_ddiskattach1" {
  managed_disk_id    = azurerm_managed_disk.hsw_ddisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.hsw_vm1.id
  lun                = "0"
  caching            = "None"
}

###############WBS###############
## Create an availability set
## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set>
resource "azurerm_availability_set" "wbs_aset" {
  name                = "${var.wbs_epicappname}_Nonprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "wbs_nic0" {
  name                = "${var.wbs_servername0}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wss_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.wbs_ip_address0
  }
  
  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_network_interface" "wbs_nic1" {
  name                = "${var.wbs_servername1}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wss_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.wbs_ip_address1
  }
  
  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "wbs_vm0" {
  name                = var.wbs_servername0
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.wbs_aset.id
  network_interface_ids = [
    azurerm_network_interface.wbs_nic0.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.wbs_servername0}_OSdisk"	
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_windows_virtual_machine" "wbs_vm1" {
  name                = var.wbs_servername1
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.wbs_aset.id
  network_interface_ids = [
    azurerm_network_interface.wbs_nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.wbs_servername1}_OSdisk"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "wbs_ddisk0" {
  name                          = "${var.wbs_servername0}_datadisk_0"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_managed_disk" "wbs_ddisk1" {
  name                          = "${var.wbs_servername1}_datadisk_1"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.wbs_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "wbs_ddiskattach0" {
  managed_disk_id    = azurerm_managed_disk.wbs_ddisk0.id
  virtual_machine_id = azurerm_windows_virtual_machine.wbs_vm0.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_virtual_machine_data_disk_attachment" "wbs_ddiskattach1" {
  managed_disk_id    = azurerm_managed_disk.wbs_ddisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.wbs_vm1.id
  lun                = "0"
  caching            = "None"
}

###############ic###############
## Create an availability set
## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set>
resource "azurerm_availability_set" "ic_aset" {
  name                = "${var.ic_epicappname}_Nonprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "ic_nic0" {
  name                = "${var.ic_servername0}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wss_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.ic_ip_address0
  }
  
  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_network_interface" "ic_nic1" {
  name                = "${var.ic_servername1}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wss_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.ic_ip_address1
  }
  
  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "ic_vm0" {
  name                = var.ic_servername0
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.ic_aset.id
  network_interface_ids = [
    azurerm_network_interface.ic_nic0.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.ic_servername0}_OSdisk"	
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_windows_virtual_machine" "ic_vm1" {
  name                = var.ic_servername1
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.ic_aset.id
  network_interface_ids = [
    azurerm_network_interface.ic_nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.ic_servername1}_OSdisk"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "ic_ddisk0" {
  name                          = "${var.ic_servername0}_datadisk_0"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_managed_disk" "ic_ddisk1" {
  name                          = "${var.ic_servername1}_datadisk_1"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.ic_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "ic_ddiskattach0" {
  managed_disk_id    = azurerm_managed_disk.ic_ddisk0.id
  virtual_machine_id = azurerm_windows_virtual_machine.ic_vm0.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_virtual_machine_data_disk_attachment" "ic_ddiskattach1" {
  managed_disk_id    = azurerm_managed_disk.ic_ddisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.ic_vm1.id
  lun                = "0"
  caching            = "None"
}

###############Cloud Connector###############
## Create an availability set
## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set>
resource "azurerm_availability_set" "cc_aset" {
  name                = "${var.cc_epicappname}_Nonprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "cc_nic0" {
  name                = "${var.cc_servername0}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hyperspace_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.cc_ip_address0
  }
  
  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_network_interface" "cc_nic1" {
  name                = "${var.cc_servername1}_nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hyperspace_subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.cc_ip_address1
  }
  
  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "cc_vm0" {
  name                = var.cc_servername0
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.cc_aset.id
  network_interface_ids = [
    azurerm_network_interface.cc_nic0.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.cc_servername0}_OSdisk"	
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_windows_virtual_machine" "cc_vm1" {
  name                = var.cc_servername1
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  availability_set_id = azurerm_availability_set.cc_aset.id
  network_interface_ids = [
    azurerm_network_interface.cc_nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.cc_servername1}_OSdisk"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
  
  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "cc_ddisk0" {
  name                          = "${var.cc_servername0}_datadisk_0"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

resource "azurerm_managed_disk" "cc_ddisk1" {
  name                          = "${var.cc_servername1}_datadisk_1"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  storage_account_type          = var.data_storagetype
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.cc_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "cc_ddiskattach0" {
  managed_disk_id    = azurerm_managed_disk.cc_ddisk0.id
  virtual_machine_id = azurerm_windows_virtual_machine.cc_vm0.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_virtual_machine_data_disk_attachment" "cc_ddiskattach1" {
  managed_disk_id    = azurerm_managed_disk.cc_ddisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.cc_vm1.id
  lun                = "0"
  caching            = "None"
}

###############System Pulse###############
module "sp_vm" {

  source             = "./modules/azure-virtual-machine"
  
  servername         = var.sp_servername
  location           = data.azurerm_resource_group.rg.location
  rgname             = data.azurerm_resource_group.rg.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.sp_ip_address
  epicappname        = "SystemPulse"
  vm_size            = var.vm_size
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############Kuiper###############
module "kuiper_vm" {

  source             = "./modules/azure-virtual-machine"
  
  servername         = var.kpr_servername
  location           = data.azurerm_resource_group.rg.location
  rgname             = data.azurerm_resource_group.rg.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.kpr_ip_address
  epicappname        = "Kuiper"
  vm_size            = var.vm_size
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############SQL###############

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server>
resource "azurerm_mssql_server" "sqlserver" {
  name                          = "epic-azr-db00"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name  
  version                       = "12.0"
  administrator_login           = var.sql_username
  administrator_login_password  = var.sql_password
  
  tags = {
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database>
resource "azurerm_mssql_database" "kuiperdb" {
  name                          = "Kuiper"
  server_id                     = azurerm_mssql_server.sqlserver.id
  license_type                  = "BasePrice"
  max_size_gb                   = 250
  sku_name                      = "S1"
  
  
  tags = {
	Terraform = "Yes"
  }
}

resource "azurerm_mssql_database" "bcadb" {
  name                          = "BCAWeb"
  server_id                     = azurerm_mssql_server.sqlserver.id  
  license_type                  = "BasePrice"
  max_size_gb                   = 250
  sku_name                      = "S1"
  
  
  tags = {
	Terraform = "Yes"
  }
}
resource "azurerm_mssql_database" "pulsedb" {
  name                          = "SystemPulse"
  server_id                     = azurerm_mssql_server.sqlserver.id  
  license_type                  = "BasePrice"
  max_size_gb                   = 250
  sku_name                      = "S1"
  
  
  tags = {
	Terraform = "Yes"
  }
}