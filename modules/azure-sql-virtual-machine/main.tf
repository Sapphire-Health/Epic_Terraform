## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface>
resource "azurerm_network_interface" "nic" {
  name                          = "${var.servername}_nic"
  location                      = var.location
  resource_group_name           = var.rgname
  enable_accelerated_networking = "true"
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
	private_ip_address            = var.ip_address
	
  }
  
  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine>
resource "azurerm_windows_virtual_machine" "vm" {
  name                      = var.servername
  resource_group_name       = var.rgname
  location                  = var.location
  size                      = var.vm_size
  availability_set_id       = var.aset_id
  admin_username            = var.admin_username
  admin_password            = var.admin_password
  timezone                  = var.timezone
  enable_automatic_updates  = var.enable_autoupdate
  patch_mode                = var.patch_mode
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
	name                 = "${var.servername}_OSdisk"	
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2019"
    sku       = "standard-gen2"
    version   = "latest"
  }
  
  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "datadisk" {
  name                          = "${var.servername}_datadisk_0"
  location                      = var.location
  resource_group_name           = var.rgname
  storage_account_type          = "StandardSSD_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "datadiskattach" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "0"
  caching            = "None"
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "logdisk" {
  name                          = "${var.servername}_logdisk_0"
  location                      = var.location
  resource_group_name           = var.rgname
  storage_account_type          = "StandardSSD_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "logdiskattach" {
  managed_disk_id    = azurerm_managed_disk.logdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "1"
  caching            = "None"
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "tempdisk" {
  name                          = "${var.servername}_tempdisk_0"
  location                      = var.location
  resource_group_name           = var.rgname
  storage_account_type          = "StandardSSD_LRS"
  create_option                 = "Empty"
  disk_size_gb                  = "40"
  public_network_access_enabled = "false"

  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment>
resource "azurerm_virtual_machine_data_disk_attachment" "tempdiskattach" {
  managed_disk_id    = azurerm_managed_disk.tempdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "2"
  caching            = "None"
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_machine>
resource "azurerm_mssql_virtual_machine" "sqlvm" {
  virtual_machine_id               = azurerm_windows_virtual_machine.vm.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = false
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = var.sql_password
  sql_connectivity_update_username = var.sql_username

  storage_configuration {
	disk_type = "NEW"
	storage_workload_type = "GENERAL"
	
    data_settings {
	    default_file_path = var.sql_datapath
		luns              = [0]
	}
	
	log_settings {
	    default_file_path = var.sql_logpath
		luns              = [1]
	}
	
	temp_db_settings {
	    default_file_path = var.sql_temppath
		luns              = [2]
	}
	
  }
  depends_on = [azurerm_virtual_machine_data_disk_attachment.datadiskattach, azurerm_virtual_machine_data_disk_attachment.logdiskattach, azurerm_virtual_machine_data_disk_attachment.tempdiskattach]
}

resource "azurerm_virtual_machine_extension" "domjoin" {
  name                 = "domjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  
  settings = <<SETTINGS
  {
    "Name": "lcmchealth.org",
    "OUPath": "OU=Azure,OU=EPIC Servers,OU=EPIC Infrastructure,DC=lcmchealth,DC=org",
    "User": "lcmchealth.org\\tyler.jordan",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
  
  protected_settings = <<PROTECTED_SETTINGS
  {
    "Password": "${var.domain_password}"
  }
  PROTECTED_SETTINGS
  
}