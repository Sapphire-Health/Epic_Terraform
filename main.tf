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
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.epic_mgmt_subnet
  service_endpoints    = ["Microsoft.Sql"]
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "azurefw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.azurefirewall_subnet  
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "wss_subnet" {
  name                 = "WSS"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.wss_subnet
  service_endpoints    = ["Microsoft.Sql" ] 
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hsw_subnet" {
  name                 = "HSW"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.hsw_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "cogito_subnet" {
  name                 = "Cogito"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.cogito_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "hyperspace_subnet" {
  name                 = "Hyperspace"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.hyperspace_subnet
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> 
resource "azurerm_subnet" "dmz_subnet" {
  name                 = "DMZ"
  resource_group_name  = data.azurerm_virtual_network.main_vnet.resource_group_name
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
    name                       = "HTTP_Inbound"
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
    name                       = "HTTPS_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Kuiper_Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["135","5985-5986"]
    source_address_prefixes    = var.kpr_ip_address
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
    name                       = "HTTP_Inbound"
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
    name                       = "HTTPS_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Kuiper_Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["135","5985-5986"]
    source_address_prefixes    = var.kpr_ip_address
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
    name                       = "HTTP_Inbound"
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
    name                       = "HTTPS_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Kuiper_Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["135","5985-5986"]
    source_address_prefixes    = var.kpr_ip_address
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
    name                       = "HTTP_Inbound"
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
    name                       = "HTTPS_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "RDP_Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
  security_rule {
    name                       = "HTTP_Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS_Outbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SMB_Outbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Printing_Outbound"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
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
    name                       = "HTTPS_Inbound"
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

###############Azure Firewalls################
module "dmz_firewall" {
  source     = "./modules/azure-firewall"
  
  fwname     = var.dmzfirewall_name
  location   = data.azurerm_virtual_network.main_vnet.location
  rgname     = data.azurerm_virtual_network.main_vnet.resource_group_name
  fwsku      = "Standard"
  subnet_id  = azurerm_subnet.azurefw_subnet.id

}

###############Traffic Managers################
resource "azurerm_traffic_manager_profile" "trafficman" {
  name                   = var.trafficmanager_name
  resource_group_name    = azurerm_resource_group.rg_mgmt.name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = var.trafficmanager_name
    ttl           = 60
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  tags = {
    Terraform = "Yes"
  }
}

###############Automation Account################
resource "azurerm_automation_account" "automationacct" {
  name                = var.automation_acctname
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  location            = azurerm_resource_group.rg_mgmt.location
  sku_name            = "Basic"

  tags = {
    Terraform = "Yes"
  }
}

###############Log Analytics Workspacet################
resource "azurerm_log_analytics_workspace" "logws" {
  name                = var.logws_name
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  location            = azurerm_resource_group.rg_mgmt.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###############BCA###############
resource "azurerm_availability_set" "bca_aset" {
  name                = "${var.bca_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.bca_epicappname
	Terraform = "Yes"
  }
}
module "bca_vms" {
  count              = var.vm_count["bca"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.bca_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.bca_ip_address[count.index]
  epicappname        = var.bca_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.bca_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"
  domain_password    = var.domain_password
}

###############BCA Web###############
resource "azurerm_availability_set" "bcaw_aset" {
  name                = "${var.bcaw_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.bcaw_epicappname
	Terraform = "Yes"
  }
}
module "bcaw_vms" {
  count              = var.vm_count["bcaw"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.bcaw_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.bcaw_ip_address[count.index]
  epicappname        = var.bcaw_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.bcaw_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Care Everywhere###############
resource "azurerm_availability_set" "ce_aset" {
  name                = "${var.ce_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.ce_epicappname
	Terraform = "Yes"
  }
}
module "ce_vms" {
  count              = var.vm_count["ce"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.ce_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.ce_ip_address[count.index]
  epicappname        = var.ce_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.ce_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Care Everywhere RP###############
resource "azurerm_availability_set" "cerp_aset" {
  name                = "${var.cerp_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.cerp_epicappname
	Terraform = "Yes"
  }
}
module "cerp_vms" {
  count              = var.vm_count["cerp"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.cerp_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.cerp_ip_address[count.index]
  epicappname        = var.cerp_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.cerp_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Citrix Cloud Connector###############
resource "azurerm_availability_set" "citrixcc_aset" {
  name                = "${var.citrixcc_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    EpicApp = var.citrixcc_epicappname
	Terraform = "Yes"
  }
}
module "cc_vms" {
  count              = var.vm_count["citrixcc"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.citrixcc_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.epic_mgmt_subnet.id
  ip_address         = var.citrixcc_ip_address[count.index]
  epicappname        = var.citrixcc_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.citrixcc_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Citrix Storefront###############
resource "azurerm_availability_set" "citrixsf_aset" {
  name                = "${var.citrixsf_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    EpicApp = var.citrixsf_epicappname
	Terraform = "Yes"
  }
}
module "sf_vms" {
  count              = var.vm_count["citrixsf"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.citrixsf_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.epic_mgmt_subnet.id
  ip_address         = var.citrixsf_ip_address[count.index]
  epicappname        = var.citrixsf_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.citrixsf_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############DSS###############
resource "azurerm_availability_set" "dss_aset" {
  name                = "${var.dss_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.dss_epicappname
	Terraform = "Yes"
  }
}
module "dss_vms" {
  count              = var.vm_count["dss"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.dss_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.dss_ip_address[count.index]
  epicappname        = var.dss_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.dss_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############EpicCare Link###############
resource "azurerm_availability_set" "eclink_aset" {
  name                = "${var.eclink_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.eclink_epicappname
	Terraform = "Yes"
  }
}
module "eclink_vms" {
  count              = var.vm_count["eclink"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.eclink_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.eclink_ip_address[count.index]
  epicappname        = var.eclink_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.eclink_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Epic Print Service###############
resource "azurerm_availability_set" "eps_aset" {
  name                = "${var.eps_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.eps_epicappname
	Terraform = "Yes"
  }
}
module "eps_vms" {
  count              = var.vm_count["eps"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.eps_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.eps_ip_address[count.index]
  epicappname        = var.eps_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.eps_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Fax Server###############
resource "azurerm_availability_set" "fax_aset" {
  name                = "${var.fax_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.fax_epicappname
	Terraform = "Yes"
  }
}
module "fax_vms" {
  count              = var.vm_count["fax"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.fax_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.fax_ip_address[count.index]
  epicappname        = var.fax_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.fax_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############HSW###############
resource "azurerm_availability_set" "hsw_aset" {
  name                = "${var.hsw_epicappname}_ASET"
  location            = azurerm_resource_group.rg_hsw.location
  resource_group_name = azurerm_resource_group.rg_hsw.name
  
  tags = {
    EpicApp = var.hsw_epicappname
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
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.hsw_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "false"
  patch_mode         = "Manual"  
  domain_password    = var.domain_password
}

###############Interconnect Background###############
resource "azurerm_availability_set" "icbg_aset" {
  name                = "${var.icbg_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.icfg_epicappname
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
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.icbg_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Interconnect Foreground###############
resource "azurerm_availability_set" "icfg_aset" {
  name                = "${var.icfg_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.icfg_epicappname
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
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.icfg_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############IVR###############
resource "azurerm_availability_set" "ivr_aset" {
  name                = "${var.ivr_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.ivr_epicappname
	Terraform = "Yes"
  }
}
module "ivr_vms" {
  count              = var.vm_count["ivr"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.ivr_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.ivr_ip_address[count.index]
  epicappname        = var.ivr_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.ivr_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############Kuiper###############
resource "azurerm_availability_set" "kpr_aset" {
  name                = "${var.kpr_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    EpicApp = var.kpr_epicappname
	Terraform = "Yes"
  }
}
module "kpr_vms" {
  count              = var.vm_count["kpr"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.kpr_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.epic_mgmt_subnet.id
  ip_address         = var.kpr_ip_address[count.index]
  epicappname        = var.kpr_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.kpr_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############MyChart###############
resource "azurerm_availability_set" "myc_aset" {
  name                = "${var.myc_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.myc_epicappname
	Terraform = "Yes"
  }
}

## <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group>
resource "azurerm_ip_group" "myc_ipgrp" {
  name                = "${var.myc_epicappname}-ipgroup"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name

  cidrs = var.myc_ip_address

  tags = {
    EpicApp = var.myc_epicappname
	Terraform = "Yes"
  }
}

module "myc_vms" {
  count              = var.vm_count["myc"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.myc_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.myc_ip_address[count.index]
  epicappname        = var.myc_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.myc_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############System Pulse###############
resource "azurerm_availability_set" "sp_aset" {
  name                = "${var.sp_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    EpicApp = var.sp_epicappname
	Terraform = "Yes"
  }
}
module "sp_vms" {
  count              = var.vm_count["sp"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.sp_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.epic_mgmt_subnet.id
  ip_address         = var.sp_ip_address[count.index]
  epicappname        = var.sp_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.sp_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############WBS###############
resource "azurerm_availability_set" "wbs_aset" {
  name                = "${var.wbs_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.wbs_epicappname
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
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.wbs_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
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

###############Welcome Web###############
resource "azurerm_availability_set" "ww_aset" {
  name                = "${var.ww_epicappname}_ASET"
  location            = azurerm_resource_group.rg_wss.location
  resource_group_name = azurerm_resource_group.rg_wss.name
  
  tags = {
    EpicApp = var.ww_epicappname
	Terraform = "Yes"
  }
}
module "ww_vms" {
  count              = var.vm_count["ww"]

  source             = "./modules/azure-virtual-machine"
  servername         = "EPIC-AZR-${var.ww_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_wss.location
  rgname             = azurerm_resource_group.rg_wss.name
  subnet_id          = azurerm_subnet.wss_subnet.id
  ip_address         = var.ww_ip_address[count.index]
  epicappname        = var.ww_epicappname
  vm_size            = var.vm_sku_2cpu
  aset_id            = azurerm_availability_set.ww_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

###############SQL###############

resource "azurerm_availability_set" "sql_aset" {
  name                = "${var.sql_epicappname}_ASET"
  location            = azurerm_resource_group.rg_mgmt.location
  resource_group_name = azurerm_resource_group.rg_mgmt.name
  
  tags = {
    EpicApp = var.sql_epicappname
	Terraform = "Yes"
  }
}

module "sql_vms" {
  count              = var.vm_count["sql"]

  source             = "./modules/azure-sql-virtual-machine"
  servername         = "EPIC-AZR-${var.sql_epicappname}${count.index}"
  location           = azurerm_resource_group.rg_mgmt.location
  rgname             = azurerm_resource_group.rg_mgmt.name
  subnet_id          = azurerm_subnet.epic_mgmt_subnet.id
  ip_address         = var.sql_ip_address[count.index]
  epicappname        = var.sql_epicappname
  vm_size            = var.vm_sku_4cpu
  aset_id            = azurerm_availability_set.sql_aset.id
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  sql_username       = var.sql_username
  sql_password       = var.sql_password
  sql_datapath       = var.sql_datapath
  sql_logpath        = var.sql_logpath
  sql_temppath       = var.sql_temppath
  enable_autoupdate  = "true"
  patch_mode         = "AutomaticByOS"  
  domain_password    = var.domain_password
}

