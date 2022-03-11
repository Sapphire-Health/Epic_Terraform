resource "azurerm_public_ip" "pip" {
  name                = "${var.fwname}-pip"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower(var.fwname)
  tags = {
	Terraform = "Yes"
  }
}

resource "azurerm_firewall" "fw01" {
  name                = var.fwname
  location            = var.location
  resource_group_name = var.rgname
  sku_tier            = var.fwsku

  ip_configuration {
    name                 = "${var.fwname}-ipconfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = {
    Terraform = "Yes"
  }
}

resource "azurerm_firewall_policy" "fwpolicy" {
  name                = "${var.fwname}-fwpolicy"
  resource_group_name = var.rgname
  location            = var.location
}