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

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network>
data "azurerm_virtual_network" "main_vnet" {
  name                = var.main_vnet_name
  resource_group_name = var.main_vnet_rg
}


###############Create Resource Groups##################
resource "azurerm_resource_group" "rg_mgmt" {
  name     = "RG-Epic-Mgmt"
  location = var.location
  tags = {
	Terraform = "Yes"
  }
}

resource "azurerm_resource_group" "rg_wss" {
  name     = "RG-Epic-WSS"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

resource "azurerm_resource_group" "rg_hsw" {
  name     = "RG-Epic-HSW"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

resource "azurerm_resource_group" "rg_hyperspace" {
  name     = "RG-Epic-Hyperspace"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

resource "azurerm_resource_group" "rg_cogito" {
  name     = "RG-Epic-Cogito"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

resource "azurerm_resource_group" "rg_dmz" {
  name     = "RG-Epic-DMZ"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

resource "azurerm_resource_group" "rg_storage" {
  name     = "RG-Epic-Storage"
  location = var.location
  tags = {
	Terraform = "Yes"
  }  
}

###############Create shared VNET resources###############

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "epic_mgmt_subnet" {
  name                 = "Epic_Mgmt"
  resource_group_name  = azurerm_resource_group.rg_mgmt.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.epic_mgmt_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "azurefw_subnet" {
  name                 = "AzureFirewall"
  resource_group_name  = azurerm_resource_group.rg_dmz.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.azurefirewall_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "wss_subnet" {
  name                 = "WSS"
  resource_group_name  = azurerm_resource_group.rg_wss.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.wss_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hsw_subnet" {
  name                 = "HSW"
  resource_group_name  = azurerm_resource_group.rg_hsw.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.hsw_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "cogito_subnet" {
  name                 = "Cogito"
  resource_group_name  = azurerm_resource_group.rg_cogito.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.cogito_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hyperspace_subnet" {
  name                 = "Hyperspace"
  resource_group_name  = azurerm_resource_group.rg_hyperspace.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.hyperspace_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "dmz_subnet" {
  name                 = "DMZ"
  resource_group_name  = azurerm_resource_group.rg_dmz.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.dmz_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "epic_mgmt_nsg" {
  name                 = "Epic_Mgmt-NSG"
  location             = azurerm_resource_group.rg_mgmt.location
  resource_group_name  = azurerm_resource_group.rg_mgmt.name
  
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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "wss_nsg" {
  name                 = "WSS-NSG"
  location             = azurerm_resource_group.rg_wss.location
  resource_group_name  = azurerm_resource_group.rg_wss.name
  
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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "hsw_nsg" {
  name                 = "HSW-NSG"
  location             = azurerm_resource_group.rg_hsw.location
  resource_group_name  = azurerm_resource_group.rg_hsw.name
  
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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "cogito_nsg" {
  name                 = "Cogito-NSG"
  location             = azurerm_resource_group.rg_cogito.location
  resource_group_name  = azurerm_resource_group.rg_cogito.name
  
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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "hyperspace_nsg" {
  name                 = "Hyperspace-NSG"
  location             = azurerm_resource_group.rg_hyperspace.location
  resource_group_name  = azurerm_resource_group.rg_hyperspace.name
  
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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group>
resource "azurerm_network_security_group" "dmz_nsg" {
  name                 = "DMZ-NSG"
  location             = azurerm_resource_group.rg_dmz.location
  resource_group_name  = azurerm_resource_group.rg_dmz.name

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
  tags = {
	Terraform = "Yes"
  }    
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "epic_mgmt_nsg_attach" {
  subnet_id                 = azurerm_subnet.epic_mgmt_subnet.id
  network_security_group_id = azurerm_network_security_group.epic_mgmt_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "wss_nsg_attach" {
  subnet_id                 = azurerm_subnet.wss_subnet.id
  network_security_group_id = azurerm_network_security_group.wss_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "hsw_nsg_attach" {
  subnet_id                 = azurerm_subnet.hsw_subnet.id
  network_security_group_id = azurerm_network_security_group.hsw_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "cogito_nsg_attach" {
  subnet_id                 = azurerm_subnet.cogito_subnet.id
  network_security_group_id = azurerm_network_security_group.cogito_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "hyperspace_nsg_attach" {
  subnet_id                 = azurerm_subnet.hyperspace_subnet.id
  network_security_group_id = azurerm_network_security_group.hyperspace_nsg.id
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association>
resource "azurerm_subnet_network_security_group_association" "dmz_nsg_attach" {
  subnet_id                 = azurerm_subnet.dmz_subnet.id
  network_security_group_id = azurerm_network_security_group.dmz_nsg.id
}

###############HSW###############
resource "azurerm_availability_set" "hsw_aset" {
  name                = "${var.hsw_epicappname}_ASET"
  location            = azurerm_resource_group.rg_hsw.location
  resource_group_name = azurerm_resource_group.rg_hsw.name
  
  tags = {
    Application = var.hsw_epicappname
	Terraform = "Yes"
  }
}
module "hsw_vms" {
  count              = var.vm_count["hsw"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.hsw_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_hsw.location
  rgname             = azurerm_resource_group.rg_hsw.name
  subnet_id          = azurerm_subnet.hsw_subnet.id
  ip_address         = var.hsw_ip_address[count.index]
  epicappname        = var.hsw_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.hsw_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############WBS###############
resource "azurerm_availability_set" "wbs_aset" {
  name                = "${var.wbs_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    Application = var.wbs_epicappname
	Terraform = "Yes"
  }
}

module "wbs_vms" {
  count              = var.vm_count["wbs"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.wbs_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.wbs_ip_address[count.index]
  epicappname        = var.wbs_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.wbs_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

resource "azurerm_storage_account" "wbsstorage" {
	name = var.wbs_storagename
	resource_group_name = azurerm_resource_group.rg_storage.name
	location = azurerm_resource_group.rg_storage.location
	account_kind = "StorageV2"
	account_tier = "Standard"
	account_replication_type = "ZRS"
	access_tier = "Hot"
}

###############Interconnect Foreground###############
resource "azurerm_availability_set" "icfg_aset" {
  name                = "${var.icfg_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    Application = var.icfg_epicappname
	Terraform = "Yes"
  }
}
module "icfg_vms" {
  count              = var.vm_count["icfg"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.icfg_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.icfg_ip_address[count.index]
  epicappname        = var.icfg_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.icfg_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############Interconnect Background###############
resource "azurerm_availability_set" "icbg_aset" {
  name                = "${var.icbg_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    Application = var.icfg_epicappname
	Terraform = "Yes"
  }
}
module "icbg_vms" {
  count              = var.vm_count["icbg"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.icbg_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.icbg_ip_address[count.index]
  epicappname        = var.icbg_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.icbg_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############Cloud Connector###############
resource "azurerm_availability_set" "citrixcc_aset" {
  name                = "${var.citrixcc_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    Application = var.citrixcc_epicappname
	Terraform = "Yes"
  }
}
module "cc_vms" {
  count              = var.vm_count["citrixcc"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.citrixcc_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.citrixcc_ip_address[count.index]
  epicappname        = var.citrixcc_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.citrixcc_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############System Pulse###############
resource "azurerm_availability_set" "sp_aset" {
  name                = "${var.sp_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    Application = var.sp_epicappname
	Terraform = "Yes"
  }
}
module "sp_vms" {
  count              = var.vm_count["sp"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.sp_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.sp_ip_address[count.index]
  epicappname        = var.sp_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.sp_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############Kuiper###############
resource "azurerm_availability_set" "kpr_aset" {
  name                = "${var.kpr_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    Application = var.kpr_epicappname
	Terraform = "Yes"
  }
}
module "kupier_vms" {
  count              = var.vm_count["kpr"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.kpr_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.kpr_ip_address[count.index]
  epicappname        = var.kpr_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.kpr_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############MyChart###############
resource "azurerm_availability_set" "myc_aset" {
  name                = "${var.myc_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    Application = var.myc_epicappname
	Terraform = "Yes"
  }
}
module "mychart_vms" {
  count              = var.vm_count["myc"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.myc_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.myc_ip_address[count.index]
  epicappname        = var.myc_epicappname
  vm_size            = var.vm_size
  aset_id            = azurerm_availability_set.myc_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  domain_password    = var.domain_password
}

###############SQL###############

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server>
resource "azurerm_mssql_server" "sqlserver" {
  name                          = "epic-azr-db00"
  location                      = azurerm_resource_group.rg_wss.location
  resource_group_name           = azurerm_resource_group.rg_wss.name  
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