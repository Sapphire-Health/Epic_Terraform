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
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  tags = {
    EpicApp = var.epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk>
resource "azurerm_managed_disk" "ddisk" {
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
resource "azurerm_virtual_machine_data_disk_attachment" "ddiskattach" {
  managed_disk_id    = azurerm_managed_disk.ddisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "0"
  caching            = "None"
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

##<https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule>
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  location           = var.location
  enabled            = var.shutdown

  daily_recurrence_time = "1800"
  timezone              = var.timezone

  notification_settings {
    enabled         = false
    time_in_minutes = "60"
    webhook_url     = "https://sample-webhook-url.example.com"
  }
}

##resource "azurerm_backup_protected_vm" "vmbackup" {
##  resource_group_name = var.rgname
##  recovery_vault_name = var.vault
##  source_vm_id        = azurerm_virtual_machine.vm.id
##  backup_policy_id    = var.policy
}