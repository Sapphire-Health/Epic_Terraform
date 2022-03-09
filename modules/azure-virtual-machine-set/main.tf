## Create an availability set
## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set>
resource "azurerm_availability_set" "aset" {
  name                = "${var.appname}_ASET"
  location            = var.location
  resource_group_name = var.rgname
  
  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}


## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "nic0" {
  name                = "${var.servername0}_nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.ip_address0
  }
  
  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "nic1" {
  name                = "${var.servername1}_nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.ip_address1
  }
  
  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "vm0" {
  name                = var.servername0
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  network_interface_ids = [
    azurerm_network_interface.nic0.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.servername0}_OSdisk"	
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "vm1" {
  name                = var.servername1
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  timezone            = var.timezone
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.servername1}_OSdisk"	
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "ddisk0" {
  name                          = "${var.servername0}_datadisk_0"
  location                      = var.location
  resource_group_name           = var.rgname
  storage_account_type          = "StandardSSD_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "ddisk1" {
  name                          = "${var.servername1}_datadisk_0"
  location                      = var.location
  resource_group_name           = var.rgname
  storage_account_type          = "StandardSSD_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    Application = var.appname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "ddiskattach0" {
  managed_disk_id    = azurerm_managed_disk.ddisk0.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm0.id
  lun                = "0"
  caching            = "None"
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "ddiskattach1" {
  managed_disk_id    = azurerm_managed_disk.ddisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm1.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_virtual_machine_extension" "domjoin0" {
  name                 = "domjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm0.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  
  settings = <<SETTINGS
  {
    "Name": "var.domain_name",
    "OUPath": "var.domain_OU",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
  
  protected_settings = <<PROTECTED_SETTINGS
  {
    "User": "${var.domain_username}", 
    "Password": "${var.domain_password}"
  }
  PROTECTED_SETTINGS
  
}

resource "azurerm_virtual_machine_extension" "domjoin1" {
  name                 = "domjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  
  settings = <<SETTINGS
  {
    "Name": "var.domain_name",
    "OUPath": "var.domain_OU",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
  
  protected_settings = <<PROTECTED_SETTINGS
  {
    "User": "${var.domain_username}",
    "Password": "${var.domain_password}"
  }
  PROTECTED_SETTINGS
  
}