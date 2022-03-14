variable "servername" {
    type = string
    description = "Server name"
}

variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "eastus2"
}

variable "rgname" {
    type = string
    description = "Resource group name"
}

variable "subnet_id" {
    type = string
    description = "ID of the subnet"
}

variable "ip_address" {
    type = string
    description = "Private IP address"
}

variable "epicappname" {
    type = string
    description = "Which Epic application will be installed"
}

variable "vm_size" {
    type = string
    description = "Size of VM"
}

variable "aset_id" {
    type = string
    description = "Availability Set ID"
}

variable "admin_username" {
    type = string
    description = "OS administrator username for server"
	sensitive = true
}

variable "admin_password" {
    type = string
    description = "OS administrator password for server"
	sensitive = true
}

variable "sql_username" {
    type = string
    description = "SQL administrator username for server"
	sensitive = true
}

variable "sql_password" {
    type = string
    description = "SQL administrator password for server"
	sensitive = true
}

variable "sql_datapath" {
	type = string
	description = "SQL Server default data path"
}

variable "sql_logpath" {
	type = string
	description = "SQL Server default log path"
}

variable "sql_temppath" {
	type = string
	description = "SQL Server default temp path"
}

variable "timezone" {
    type = string
    description = "OS Timezone"
    default = "Central Standard Time"
}

variable "enable_autoupdate" {
    type = string
    description = "true or false to enable automatic updates"
}

variable "patch_mode" {
    type = string
    description = "Set Patch Mode to either 'Manual' or 'AutomaticByOS'"
}

variable "domain_password" {
    type = string
    description = "Domain Admin password"
	sensitive = true
}
