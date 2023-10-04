provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Subnet_RT" {
  name     = "Subnet_RT-resources"
  location = "West US"
}

resource "azurerm_virtual_network" "Subnet_RT" {
  name                = "Subnet_RT-vnet"
  resource_group_name = azurerm_resource_group.Subnet_RT.name
  location            = azurerm_resource_group.Subnet_RT.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.Subnet_RT.name
  virtual_network_name = azurerm_virtual_network.Subnet_RT.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.Subnet_RT.name
  virtual_network_name = azurerm_virtual_network.Subnet_RT.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Route Table 

resource "azurerm_route_table" "Subnet_RT" {
  name                = "Subnet_RT-route-table"
  location            = azurerm_resource_group.Subnet_RT.location
  resource_group_name = azurerm_resource_group.Subnet_RT.name

  route {
    name                   = "Subnet_RT-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4" 
  }
}

resource "azurerm_subnet_route_table_association" "subnet1_assoc" {
  subnet_id      = azurerm_subnet.subnet1.id
  route_table_id = azurerm_route_table.Subnet_RT.id
}

resource "azurerm_subnet_route_table_association" "subnet2_assoc" {
  subnet_id      = azurerm_subnet.subnet2.id
  route_table_id = azurerm_route_table.Subnet_RT.id
}


resource "azurerm_public_ip" "Subnet_RT" {
  name                = "Subnet_RT-publicip"
  location            = azurerm_resource_group.Subnet_RT.location
  resource_group_name = azurerm_resource_group.Subnet_RT.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "Subnet_RT" {
  name                = "Subnet_RT-lb"
  location            = azurerm_resource_group.Subnet_RT.location
  resource_group_name = azurerm_resource_group.Subnet_RT.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "Subnet_RT-frontend"
    public_ip_address_id = azurerm_public_ip.Subnet_RT.id
  }
}

resource "azurerm_lb_backend_address_pool" "Subnet_RT" {
  loadbalancer_id = azurerm_lb.Subnet_RT.id
  name            = "Subnet_RT-backend"
}
