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

variable "domain_password" {
    type = string
    description = "Domain Admin password"
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

variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_D2_v5"
}

variable "hsw_servername0" {
    type = string
    description = "Server name of the virtual machine"
}

variable "hsw_servername1" {
    type = string
    description = "Server name of the virtual machine"
}

variable "hsw_ip_address0" {
    type = string
    description = "Private static IP address"
}

variable "hsw_ip_address1" {
    type = string
    description = "Private static IP address"
}

variable "hsw_epicappname" {
    type = string
    description = "HSW Epic application name"
}

variable "wbs_servername0" {
    type = string
    description = "Server name of the virtual machine"
}

variable "wbs_servername1" {
    type = string
    description = "Server name of the virtual machine"
}

variable "wbs_ip_address0" {
    type = string
    description = "Private static IP address"
}

variable "wbs_ip_address1" {
    type = string
    description = "Private static IP address"
}

variable "wbs_epicappname" {
    type = string
    description = "WBS Epic application name"
}

variable "ic_servername0" {
    type = string
    description = "Server name of the virtual machine"
}

variable "ic_servername1" {
    type = string
    description = "Server name of the virtual machine"
}

variable "ic_ip_address0" {
    type = string
    description = "Private static IP address"
}

variable "ic_ip_address1" {
    type = string
    description = "Private static IP address"
}

variable "ic_epicappname" {
    type = string
    description = "IC Epic application name"
}

variable "cc_servername0" {
    type = string
    description = "Server name of the virtual machine"
}

variable "cc_servername1" {
    type = string
    description = "Server name of the virtual machine"
}

variable "cc_ip_address0" {
    type = string
    description = "Private static IP address"
}

variable "cc_ip_address1" {
    type = string
    description = "Private static IP address"
}

variable "cc_epicappname" {
    type = string
    description = "IC Epic application name"
}

variable "sp_servername" {
    type = string
    description = "Server name of the virtual machine"
}

variable "sp_ip_address" {
    type = string
    description = "Private static IP address"
}

variable "kpr_servername" {
    type = string
    description = "Server name of the virtual machine"
}

variable "kpr_ip_address" {
    type = string
    description = "Private static IP address"
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

