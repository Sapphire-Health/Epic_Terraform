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
    default = "Standard_D2_v5"
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

variable "timezone" {
    type = string
    description = "OS Timezone"
    default = "Central Standard Time"
}

variable "domain_password" {
    type = string
    description = "Domain Admin password"
	sensitive = true
}
