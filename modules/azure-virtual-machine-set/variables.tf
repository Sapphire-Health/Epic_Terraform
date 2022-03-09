variable "servername0" {
    type = string
    description = "Server name"
}

variable "servername1" {
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

variable "ip_address0" {
    type = string
    description = "Private IP address"
}

variable "ip_address1" {
    type = string
    description = "Private IP address"
}

variable "appname" {
    type = string
    description = "Which application will be installed"
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
