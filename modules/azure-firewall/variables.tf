variable "fwname" {
    type = string
    description = "Firewall name (Alphanumeric and dashes)"
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

variable "fwsku" {
    type = string
    description = "Firewall SKU (Standard or Premium)"
	default = "Standard"
}

variable "subnet_id" {
    type = string
    description = "ID of the subnet"
}