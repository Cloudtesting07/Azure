provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Prod_RG" {
  name     = "Prod_RG"
  location = "East US"
}


resource "azurerm_public_ip" "Test_PIP" {
  name                = "Test_PIP"
  location            = azurerm_resource_group.Prod_RG.location
  resource_group_name = azurerm_resource_group.Prod_RG.name
  allocation_method   = "Dynamic"
  #domain_name_label   = "dnsname"
}


#Optinal
#allocation_method   = "Static"
#ip_address          = "desired.ip.address.here"  # replace IP
 

#Command
#terraform destroy -target azurerm_public_ip.Test_PIP

