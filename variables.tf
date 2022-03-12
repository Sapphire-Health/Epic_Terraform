variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "eastus2"
}

variable "admin_username" {
    type = string
    description = "Administrator username for server"
	sensitive = true
}

variable "admin_password" {
    type = string
    description = "Administrator password for server"
	sensitive = true
}

variable "main_vnet_name" {
    type = string
    description = "Name of existing main VNET"
}

variable "main_vnet_rg" {
    type = string
    description = "Resource Group of existing main VNET"
}

variable "epic_mgmt_subnet" {
    type = list
    description = "IP Space of Epic Management subnet"
}

variable "azurefirewall_subnet" {
    type = list
    description = "IP Space of Azure Firewall subnet (must be /26)"
}

variable "wss_subnet" {
    type = list
    description = "IP Space of Web & Service Server subnet"
}

variable "hsw_subnet" {
    type = list
    description = "IP Space of Hyperspace Web subnet"
}

variable "cogito_subnet" {
    type = list
    description = "IP Space of Cogito subnet"
}

variable "hyperspace_subnet" {
    type = list
    description = "IP Space of Hyperspace VDA subnet"
}

variable "dmz_subnet" {
    type = list
    description = "IP Space of DMZ subnet"
}

variable "domain_name" {
    type = string
    description = "Account for Domain Join"
	sensitive = true
}

variable "domain_OU" {
    type = string
    description = "OU to put Domain Joined machines"
	sensitive = true
}

variable "dmzfirewall_name" {
    type = string
    description = "DNS prefix for the DMZ Firewall"
}

variable "trafficmanager_name" {
    type = string
    description = "Mychart Traffic Manager name"
}

variable "automation_acctname" {
    type = string
    description = "Automation Account name"
}

variable "logws_name" {
    type = string
    description = "Log Analytics Workspace name"
}

variable "domain_username" {
    type = string
    description = "Account for Domain Join"
	sensitive = true
}

variable "domain_password" {
    type = string
    description = "Password for Domain Join Account"
	sensitive = true
}

variable "sql_username" {
    type = string
    description = "Administrator username for SQL server"
	sensitive = true
}

variable "sql_password" {
    type = string
    description = "Administrator password for SQL server"
	sensitive = true
}

variable "data_storagetype" { 
    type = string
    description = "Disk type"
    default = "StandardSSD_LRS"
}

variable "vm_sku_2cpu" {
    type = string
    description = "SKU to use for 2 vCPU servers"
}

variable "vm_sku_4cpu" {
    type = string
    description = "SKU to use for 4 vCPU servers"
}

variable "vm_count" {
	type = map
	description = "The number of servers to build of each type"
	default = {
			"bca" = 0
			"bcaw" = 0
			"ce" = 0
			"cerp" = 0
			"citrixcc" = 0	
			"citrixsf" = 0
			"dss" = 0
			"eclink" = 0
			"eps" = 0
			"fax" = 0
			"hsw" = 0
			"icbg" = 0
			"icfg" = 0
			"ivr" = 0
			"kpr" = 0
			"myc" = 0
			"sp" = 0
			"wbs" = 0
			"ww" = 0
	}
}

variable "bca_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "bca_epicappname" {
    type = string
    description = "BCA Epic application name"
}

variable "bcaw_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "bcaw_epicappname" {
    type = string
    description = "BCAW Epic application name"
}

variable "ce_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "ce_epicappname" {
    type = string
    description = "Care Everywhere Epic application name"
}

variable "cerp_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "cerp_epicappname" {
    type = string
    description = "Care Everywhere Reverse Proxy Epic application name"
}

variable "citrixcc_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "citrixcc_epicappname" {
    type = string
    description = "Citrix Cloud Connector application name"
}

variable "citrixsf_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "citrixsf_epicappname" {
    type = string
    description = "Citrix Storefront application name"
}

variable "dss_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "dss_epicappname" {
    type = string
    description = "Digital Signing Server application name"
}

variable "eclink_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "eclink_epicappname" {
    type = string
    description = "EpicCare Link application name"
}

variable "eps_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "eps_epicappname" {
    type = string
    description = "EPS application name"
}

variable "fax_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "fax_epicappname" {
    type = string
    description = "Fax EPS server application name"
}

variable "hsw_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "hsw_epicappname" {
    type = string
    description = "HSW application name"
}

variable "icbg_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "icbg_epicappname" {
    type = string
    description = "IC background Epic application name"
}

variable "icfg_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "icfg_epicappname" {
    type = string
    description = "IC foreground Epic application name"
}

variable "ivr_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "ivr_epicappname" {
    type = string
    description = "IVR application name"
}

variable "kpr_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "kpr_epicappname" {
    type = string
    description = "Kuiper Epic application name"
}

variable "myc_ip_address" {
  type   = list
  description = "Private static IP address"
}

variable "myc_epicappname" {
    type = string
    description = "MyChart Epic application name"
}

variable "sp_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "sp_epicappname" {
    type = string
    description = "System Pulse Epic application name"
}

variable "wbs_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "wbs_epicappname" {
    type = string
    description = "WBS Epic application name"
}

variable "ww_ip_address" {
    type = list
    description = "Private static IP address"
}

variable "wbs_storagename" {
    type = string
    description = "WBS Storage Account name"
}

variable "ww_epicappname" {
    type = string
    description = "Welcome Web application name"
}

variable "sqlserver_name" {
    type = string
    description = "SQL Server name"
}


variable "timezone" {
    type = string
    description = "OS Timezone"
    default = "Central Standard Time"
}

variable "os" {
    description = "OS image to deploy"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
  })
} 
